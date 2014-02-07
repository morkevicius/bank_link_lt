require 'bank_link_lt/bank_link_common'

module BankLinkLt::Seb
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

  #according to support official at seb everything should be encoded as windows-1257

  #def initialize
  #  if self.default_required_params_hash.blank?
  #    #%w(VK_SND_ID VK_ACC VK_NAME VK_CURR )
  #
  #    self.default_required_params_hash = {
  #        'VK_SND' => self.get_account_sender_id,
  #        'VK_ACC' => self.get_account_number,
  #        'VK_NAME' => self.get_account_name,
  #        'VK_VERSION' => '008',
  #    }
  #  end
  #  self.default_required_params_hash.freeze
  #end

  #.force_encoding(Encoding::Windows_1257)
  #
  def encoding_param_hash
    {'VK_CHARSET' => 'UTF-8'}
  end

  def encode_to_default_encoding(request_params_hash)
    #request_params_hash.merge(self.encoding_param_hash)

    #request_params_hash
    request_params_hash.each{ |key, value| request_params_hash[key] = value.force_encoding(Encoding::Windows_1257) rescue value}

  end


  #default_params

  #notes about params
  #VK_CHARSET	10	 Encoding of message Optional parameter. Permitted ISO-8859-1(default value) or UTF-8

  #Service 1001
  #The merchant sends to the bank the client’s request for executing a transaction.

  #Service 1002  <- The one to use, if you want to use only sender_id, sadly but in estonia, in lithuania is 1201
  #The merchant sends to the bank the client’s request for executing a transaction. The beneficiary’s name and account
  #number are taken from the agreement signed between the bank and the merchant.

  #Service 1101
  #Response on accepting the transaction

  #Service 1901
  #Response on rejecting the transaction


  self.available_services_with_required_params =
      {
          1001 => %w(
          VK_SERVICE
          VK_VERSION
          VK_SND_ID
          VK_STAMP
          VK_AMOUNT
          VK_CURR
          VK_ACC
          VK_NAME
          VK_REF
          VK_MSG),


          1101 => %w(
          VK_SERVICE
          VK_VERSION
          VK_SND_ID
          VK_REC_ID
          VK_STAMP
          VK_T_NO
          VK_AMOUNT
          VK_CURR
          VK_ACC
          VK_REC_NAME
          VK_SND_ACC
          VK_SND_NAME
          VK_REF
          VK_MSG
          VK_T_DATE),

          1201 => %w(
          VK_SERVICE
          VK_VERSION
          VK_SND_ID
          VK_REC_ID
          VK_STAMP
          VK_AMOUNT
          VK_CURR
          VK_ACC
          VK_REC_NAME
          VK_SND_ACC
          VK_SND_NAME
          VK_REF
          VK_MSG
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