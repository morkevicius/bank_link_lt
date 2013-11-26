require 'bank_link_lt/bank_link_common'
module BankLinkLt::Swedbank
  include BankLinkLt::Common
  mattr_accessor :available_services_with_required_params
  mattr_accessor :default_required_params_hash

  mattr_accessor :preferred_language
  mattr_accessor :default_payment_service_id

  mattr_accessor :account_name
  mattr_accessor :test_account_name

  mattr_accessor :account_number
  mattr_accessor :test_account_number

  mattr_accessor :account_sender_id
  mattr_accessor :test_account_sender_id

  mattr_accessor :account_payment_gateway_url
  mattr_accessor :test_account_payment_gateway_url

  mattr_accessor :account_bank_certificate
  mattr_accessor :test_account_bank_certificate

  mattr_accessor :account_private_key
  mattr_accessor :test_account_private_key


  #notes about params
  #VK_ENCODING -  => ISO-8859-13(default), probably would like to use UTF-8
  #VK_CURR in ISO-4217 format
  #VK_VERSION = 008
  #VK_LANG LIT LAT RUS ENG
  # DATE format => „DD.MM.YYYY“, i.e. 17.02.2001
  # TIME format =>  „hh24:min:sek“, i.e. 17:02:59

  def add_encoding(request_params_hash)
    if request_params_hash.is_a?(Hash)
      request_params_hash.merge('VK_CHARSET' => 'UTF-8')
    end
  end

  def encoding_param_hash
    {'VK_CHARSET' => 'UTF-8'}
  end

  def encode_to_default_encoding(request_params_hash)
    request_params_hash.merge(self.encoding_param_hash)
    #request_params_hash.merge(self.encoding_param_hash).
    #    each { |key, value| request_params_hash[key] = value.force_encoding(Encoding:UTF_8) rescue value }
  end

  self.available_services_with_required_params = {
      1002 => %w(
          VK_SERVICE
          VK_VERSION
          VK_SND_ID
          VK_STAMP
          VK_AMOUNT
          VK_CURR
          VK_REF
          VK_MSG
          ),

      1101 => %w(
          VK_SERVICE
          VK_VERSION
          VK_SND_ID
          VK_REC_ID
          VK_STAMP
          VK_T_NO
          VK_AMOUNT
          VK_CURR
          VK_REC_ACC
          VK_REC_NAME
          VK_SND_ACC
          VK_SND_NAME
          VK_REF
          VK_MSG
          VK_T_DATE
          ),

      1901 => %w(
          VK_SERVICE
          VK_VERSION
          VK_SND_ID
          VK_REC_ID
          VK_STAMP
          VK_REF
          VK_MSG
          )
  }
  self.available_services_with_required_params.freeze


end