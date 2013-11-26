require 'bank_link_lt/version'
require 'bank_link_lt/bank_link_common'
require 'bank_link_lt/swedbank'
require 'bank_link_lt/seb'

require 'rails'
require 'active_support/dependencies'
require 'net/http'
require 'net/https'
require 'uri'

require 'digest'
require 'digest/md5'
require 'openssl'

require 'bank_link_lt/railtie' if defined?(Rails)

%w{ models controllers helpers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
end

module BankLinkLt

  class Payment
    def initialize(type, params_hash)
      if type.nil?
        return raise 'No bank type provided'

      else
        if type == 'Swedbank'
          return BankLinkLt::PaymentSwedBank.new(params_hash)
        elsif type == 'Seb'
          return BankLinkLt::PaymentSeb.new(params_hash)
        else
          raise 'Bank not recognized'
        end
      end
    end
  end
  class PaymentSwedBank
    include BankLinkLt::Swedbank

    def initialize(options = {})
      self.default_required_params_hash = {
          'VK_SND_ID' => self.get_account_sender_id,
          'VK_SND_ACC' => self.get_account_number,
          'VK_SND_NAME' => self.get_account_name,
          'VK_VERSION' => '008',
          'VK_ENCODING' => 'UTF-8'
      }
      self.default_required_params_hash.freeze
    end
  end
  class PaymentSeb
    include BankLinkLt::Seb

    def initialize(options = {})

      self.default_required_params_hash = {
          'VK_SND_ID' => self.get_account_sender_id,
          'VK_ACC' => self.get_account_number,
          'VK_NAME' => self.get_account_name,
          'VK_VERSION' => '008',
          'VK_CHARSET' => 'WINDOWS-1257'
      }

      self.default_required_params_hash.freeze
    end

  end
  class CallbackSwedBank
    include BankLinkLt::Swedbank

    attr_accessor :params

    # set this to an array in the subclass, to specify which IPs are allowed to send requests
    attr_accessor :production_ips

    def initialize(params, options = {})
      @options = options
      @params = params

    end

    def gross_cents
      (amount.to_d * 100.0).round(0)
    end

    # reset the notification.
    def empty!
      @params = Hash.new
    end

    # Check if the request comes from an official IP
    def valid_sender?(ip)
      return true if Rails.env == :test || production_ips.blank?
      production_ips.include?(ip)
    end

    # A helper method to parse the raw post of the request & return
    # the right Notification subclass based on the sender id.
    #def self.get_notification(http_raw_data)
    #  params = ActiveMerchant::Billing::Integrations::Notification.new(http_raw_data).params
    #  Banklink.get_class(params)::Notification.new(http_raw_data)
    #end

    def get_data_string
      generate_data_string(params['VK_SERVICE'], params)
    end

    def bank_signature_valid?(bank_signature, service_msg_number, sigparams)
      get_bank_public_key.verify(OpenSSL::Digest::SHA1.new, bank_signature, generate_data_string(service_msg_number, sigparams))
    end

    def complete?
      params['VK_SERVICE'] == '1101'
    end

    def wait?
      params['VK_SERVICE'] == '1201'
    end

    def failed?
      params['VK_SERVICE'] == '1901'
    end

    def currency
      params['VK_CURR']
    end

    # The order id we passed to the form helper.
    def order_id
      params['VK_REF']
    end

    def transaction_id
      params['VK_T_NO']
    end

    def sender_name
      params['VK_SND_NAME']
    end

    def payment_id_in_bank_records
      params['VK_T_NO']
    end

    def sender_bank_account
      params['VK_SND_ACC']
    end

    def receiver_name
      params['VK_REC_NAME']
    end

    def receiver_bank_account
      params['VK_REC_ACC']
    end

    def payment_date
      date = Date.parse(params['VK_T_DATE']) rescue nil
    end

    def signature
      Base64.decode64(params['VK_MAC'])
    end

    # The money amount we received, string.
    def amount
      params['VK_AMOUNT']
    end

    # If our request was sent automatically by the bank (true) or manually
    # by the user triggering the callback by pressing a "return" button (false).
    def automatic?
      params['VK_AUTO'].upcase == 'Y'
    end

    def success?
      verify && complete?
    end

    def verify
      #Rails.logger.debug('signature ')
      #Rails.logger.debug(signature)
      #Rails.logger.debug(' end of signature')
      #Rails.logger.debug('params ')
      #Rails.logger.debug(params)
      #Rails.logger.debug(' end of params')

      bank_signature_valid?(signature, params['VK_SERVICE'].to_i, params)
    end


  end
  class CallbackSeb
    include BankLinkLt::Seb

    attr_accessor :params

    # set this to an array in the subclass, to specify which IPs are allowed to send requests
    attr_accessor :production_ips

    def initialize(params, options = {})
      @options = options
      @params = params

    end

    def gross_cents
      (amount.to_d * 100.0).round(0)
    end

    # reset the notification.
    def empty!
      @params = Hash.new
    end

    # Check if the request comes from an official IP
    def valid_sender?(ip)
      return true if Rails.env == :test || production_ips.blank?
      production_ips.include?(ip)
    end

    # A helper method to parse the raw post of the request & return
    # the right Notification subclass based on the sender id.
    #def self.get_notification(http_raw_data)
    #  params = ActiveMerchant::Billing::Integrations::Notification.new(http_raw_data).params
    #  Banklink.get_class(params)::Notification.new(http_raw_data)
    #end

    def get_data_string
      generate_data_string(params['VK_SERVICE'].to_i, params)
    end

    def bank_signature_valid?(bank_signature, service_msg_number, sigparams)
      get_bank_public_key.verify(OpenSSL::Digest::SHA1.new, bank_signature, generate_data_string(service_msg_number, sigparams))
    end

    def complete?
      params['VK_SERVICE'] == '1101'
    end

    def wait?
      params['VK_SERVICE'] == '1201'
    end

    def failed?
      params['VK_SERVICE'] == '1901'
    end

    def currency
      params['VK_CURR']
    end

    # The order id we passed to the form helper.
    def order_id
      params['VK_REF']
    end

    def transaction_id
      params['VK_T_NO']
    end

    def sender_name
      params['VK_SND_NAME']
    end

    def payment_id_in_bank_records
      params['VK_T_NO']
    end

    def sender_bank_account
      params['VK_SND_ACC']
    end

    def receiver_name
      params['VK_REC_NAME']
    end

    def receiver_bank_account
      params['VK_REC_ACC']
    end

    def payment_date
      date = Date.parse(params['VK_T_DATE']) rescue nil
    end

    def signature
      Base64.decode64(params['VK_MAC'])
    end

    # The money amount we received, string.
    def amount
      params['VK_AMOUNT']
    end

    # If our request was sent automatically by the bank (true) or manually
    # by the user triggering the callback by pressing a "return" button (false).
    def automatic?
      params['VK_AUTO'].upcase == 'Y'
    end

    def success?
      verify && complete?
    end

    def verify
      bank_signature_valid?(signature, params['VK_SERVICE'].to_i, params)
    end


  end

end


#end


