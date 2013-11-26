require 'rails/generators/base'
module BankLinkLt
    class CertificatesGenerator  < Rails::Generators::Base
      desc 'generates request certificates for bank'

      CERTIFICATES_PATH = 'certificates/'
      BANKS = %w{seb swedbank}

      source_root File.expand_path(File.join(File.dirname(__FILE__)))

      class_option :certificates_subject, :type => :string, :default => '/C=LT/L=Vilnius/O=JUSU UAB/OU=BankLink/CN=www.jusu_www.lt/emailAddress=info@jusu_www.lt/'
      class_option :certificates_path, :type => :string, :default => CERTIFICATES_PATH


      def create_certificates_directory
        unless File.exist?(CERTIFICATES_PATH) || File.symlink?(CERTIFICATES_PATH)
          puts 'creating directory for certificates'
          directory(CERTIFICATES_PATH)
        else
          puts 'certificates directory exists'
        end
      end

      def generate_certificates
        puts "Will generate certificates for #{BANKS.join(', ')} \n"
        BANKS.each do |bank|
          puts "options for #{bank}: #{options[:certificates_subject]}"
          `cd #{CERTIFICATES_PATH} &&
           openssl req -new -nodes -nodes -days 720 -x509 -newkey rsa:1024 -out certificate_for_#{bank}.crt -keyout private_key_for_#{bank}.pem -subj "#{options[:certificates_subject]}" &&
           && openssl x509 -x509toreq -in certificate_for_#{bank}.crt -out #{bank}_certificate_request.csr -signkey private_key_for_#{bank}.pem`

        end
      end

      def show_certificates_info
        BANKS.each do |bank|


          puts "Certificate info for #{bank} \n"
          puts `cd #{CERTIFICATES_PATH} && openssl x509 -in certificate_for_#{bank}.crt -text -noout`

        end

      end
    end
  end
