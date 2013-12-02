module BankLinkLt::Common

  #---------------------------------------------------------------------------------------------------------------------------
  # from : http://www.seb.ee/eng/business/everyday-banking/collection-payments/collection-payments-web/bank-link-specification
  #---------------------------------------------------------------------------------------------------------------------------
  # Params Example:
  #VK_SERVICE=1901&VK_VERSION=002&VK_SND_ID=HP&VK_REC_ID=EPL001&
  #VK_STAMP=37306e24&_REF=200002086&VK_MSG=Payment%3A+order%3A+Annual%3A+subscription&
  #VK_MAC=g40uYkOzfwH5QhQaKBgNYua%2FxfE%3D&VK_LANG=EST
  #
  #Finding the check code VK_MAC based on version 008
  #Signature MAC008 (VK_MAC) is calculated by using the public key algorithm RSA and hash algorithm SHAI.
  #MAC008(x1,x2,..., xn):= RSA (SHA-1(p(x1) || x1 || p(x2) || x2 || ... || p(xn) || xn),d,n)
  #---------------------------------------------------------------------------------------------------------------------------

  #---------------------------------------------------------------------------------------------------------------------------
  # from : http://www.swedbank.lt/files/Banklink_TC_en.pdf
  #---------------------------------------------------------------------------------------------------------------------------
  #VK_MAC control code calculation
  #VK_MAC, for electronic signature, using in the request, for checking and confirming used version of the
  #algorithm, indicated in the parameter VK_VERSION. In this time version 008 is used.
  #VK_MAC is presented as a request parameter in BASE64 coding.
  #Version 008
  #The value of the MAC008 function is calculated using the public key algorithm RSA. Values of empty fields
  #are taken into account as well – “000”.
  #    MAC008(x 1,x2,...,x n) := RSA( SHA-1(p(x 1 )|| x 1|| p(x 2 )|| x 2 || ... ||p( xn )||x n),d,n)
  #Where:
  #    || is an operation of adding the string
  #x1 , x2, ..., xn are the query
  #parameters
  #p is a function of the parameter length. The length is a number in the form of a three-digit string
  #d is the RSA secret exponent
  #n is the RSA modulus
  #The signature is calculated in accordance with the PKCS1 standard (RFC 2437).
  #Example:
  #Let us take a query with the following parameters:
  #VK_SERVICE=1002
  #VK_VERSION=008
  #VK_SND_ID=TRADER
  #VK_STAMP=1234567890
  #VK_AMOUNT=1.99
  #VK_CURR=LVL
  #VK_REF=01012001-001
  #VK_MSG=Payment for a good XXXXXX
  # The signature is calculated from the following data row which comprises the following elements (the
  # number of the symbols of the parameter values and the value of the parameter itself):
  # 0041002
  # 003008
  # 006TRADER
  # 0101234567890
  # 0041.99
  # 003LVL
  # 01201012001-001
  # 025Payment for a good XXXXXX
  # in one row:
  #“0041002003008006TRADER01012345678900041.99003LVL01201012001-001025Payment for a11good XXXXXX”
  # or if the VK_MSG parameter is empty, the result:
  # “0041002003008006TRADER01012345678900041.99003LVL01201012001-001000”


  def validate_bank_signature(params={})
    if !params.empty?
      signature = Base64.decode64(params['VK_MAC'])
      self.get_bank_public_key.verify(OpenSSL::Digest::SHA1.new, signature, generate_data_string(params['VK_SERVICE'].to_i, params))
    else
      false
    end
  end

  def normalize_length(val)
    sprintf('%03i', val.length)
  end

  def generate_data_string(service_id, request_params_hash)
    if service_id.is_a?(Integer) && request_params_hash.is_a?(Hash)
      if self.requests.include?(service_id)
        str = ''
        self.request_params(service_id).each do |param|
          val = request_params_hash[param].to_s # nil goes to ''
          str << normalize_length(val) << val
        end
        str
      else
        raise "invalid service id => #{service_id.inspect}, self.requests => #{self.requests.inspect}"
      end
    else
      raise 'service_id is not a integer or request_params_hash is not a hash'
    end
  end

  def requests
    self.available_services_with_required_params.keys
  end

  def request_params(request)
    if self.requests.include?(request)
      self.available_services_with_required_params[request]
    else
      raise "Unsupported request => #{request.inspsect}"
    end
  end

  def payment(options={})
    #order_id, amount, currency, message, service_id, return_url

    #puts "amount => #{amount} \n"
    #puts "order_id => #{order_id} \n"
    #puts "message => #{message} \n"
    #puts "amount => #{currency} \n"
    #puts "service_id => #{service_id} \n"
    if options.empty? || options[:order_id].nil? || options[:amount].nil? || options[:currency].nil? || options[:message].nil? || options[:service_id].nil? || options[:return_url].nil?
      raise 'not enough params' + "options.nil? => #{options.nil?}, options[:order_id].nil? => #{options[:order_id].nil?}, options[:amount].nil? => #{options[:amount].nil?},  options[:currency].nil? => #{options[:currency].nil?},  options[:message].nil? => #{options[:message].nil?}, options[:service_id].nil? => #{options[:service_id].nil?}, options[:return_url].nil? => #{options[:return_url].nil?}"

    end
    @request_params_hash = self.generate_request_params_hash(options[:service_id], options[:amount], options[:order_id], options[:message], options[:currency])
    @request_params_hash = self.add_return_url(@request_params_hash, options[:return_url])
    @request_params_hash = add_lang_param(@request_params_hash)
    @request_params_hash = self.encode_to_default_encoding(@request_params_hash)
    @request_params_hash = self.add_mac_to_request_params_hash(options[:service_id], @request_params_hash)


  end

  def add_return_url(request_params_hash, return_url)
    if request_params_hash.is_a?(Hash)
      request_params_hash.merge('VK_RETURN' => return_url)
      #  seb => URL to which response is sent in performing the transaction. HTTPS URL is required | MAX_LENGTH = 60
      #  swed => URL where the transaction response query is sent (1101, 1901) | MAX_LENGTH = 150
    end
  end

  def add_mac_to_request_params_hash(service_id, request_params_hash)
    if request_params_hash.is_a?(Hash)
      request_params_hash.merge('VK_MAC' => self.generate_mac(service_id, request_params_hash))
    end
  end

  def add_lang_param(request_params_hash)
    if request_params_hash.is_a?(Hash) && !self.preferred_language.nil? && ['LIT', 'LAT', 'EST', 'ENG', 'RUS'].include?(self.preferred_language)
      request_params_hash.merge('VK_LANG' => self.preferred_language)
    end
  end

  def generate_request_params_hash(service_id, amount, order_id, message, currency)
    request_hash=Hash.new

    if self.requests.include?(service_id)
      #p "default_required_params_hash => #{self.default_required_params_hash.inspect}"
      self.request_params(service_id).each do |param|
        #puts %{request param => #{param}}
        if self.default_required_params_hash.include?(param)
          #puts "#{param} is included in default_required_params_hash, setting to request_hash #{self.default_required_params_hash[param]}"
          request_hash["#{param}"] = self.default_required_params_hash[param]
        else

          if param == 'VK_SERVICE'
            request_hash["#{param}"] = service_id.to_s
          elsif param == 'VK_STAMP'
            request_hash["#{param}"] = "#{order_id}-#{Time.now.to_i}"

          elsif param == 'VK_AMOUNT'
            request_hash["#{param}"] = sprintf('%.2f', amount)

          elsif param == 'VK_CURR'
            request_hash["#{param}"] = currency.to_s

          elsif param == 'VK_REF'
            request_hash["#{param}"] = order_id.to_s

          elsif param == 'VK_MSG'
            request_hash["#{param}"] = message.to_s


          else
            request_hash["#{param}"] = nil

          end


        end
      end

    end

    request_hash
  end

  def generate_signature(service_id, request_params_hash)
    self.get_private_key.sign(OpenSSL::Digest::SHA1.new, generate_data_string(service_id, request_params_hash))
  end

  def get_account_name
    if Rails.env == 'production'
      self.account_name
    else
      self.test_account_name
    end
  end

  def get_account_number
    if Rails.env == 'production'
      self.account_number
    else
      self.test_account_number
    end
  end

  def get_account_sender_id
    if Rails.env == 'production'
      self.account_sender_id
    else
      self.test_account_sender_id
    end
  end

  def get_payment_gateway_url
    if Rails.env == 'production'
      self.account_payment_gateway_url
    else
      self.test_account_payment_gateway_url
    end
  end

  def get_bank_public_key
    if Rails.env == 'production'
      cert = self.account_bank_certificate
    else
      cert = self.test_account_bank_certificate
    end
    OpenSSL::X509::Certificate.new(cert.gsub(/  /, '')).public_key
  end


  def get_private_key
    if Rails.env == 'production'
      private_key = self.account_private_key
    else
      private_key = self.test_account_private_key
    end
    OpenSSL::PKey::RSA.new(private_key.gsub(/  /, ''))
  end

  def generate_mac(request, request_params_hash)
    Base64.encode64(generate_signature(request, request_params_hash)).gsub(/\n/, '')
  end

end