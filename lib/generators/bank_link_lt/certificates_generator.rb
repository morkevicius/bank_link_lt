require 'rails/generators/base'
module BankLinkLt
    class CertificatesGenerator  < Rails::Generators::Base
      desc 'generates request certificates for bank'

      CERTIFICATES_PATH = 'certificates/'

      BANKS = %w{seb swedbank}

      source_root File.expand_path(File.join(File.dirname(__FILE__)))

      class_option :certificates_subject, :type => :string, :default => '/C=country_code/L=city/O=company_name/OU=BankLink/CN=www.your_www.lt/emailAddress=your_company_email/'
      class_option :certificates_path, :type => :string, :default => CERTIFICATES_PATH


      def create_certificates_directory

        unless File.directory?(Rails.root + options[:certificates_path])|| File.symlink?(Rails.root + options[:certificates_path])
          puts "Creating directory for certificates at #{File.expand_path(Rails.root +CERTIFICATES_PATH)}"
          Dir.mkdir "#{Rails.root + options[:certificates_path]}"
          #system "chmod  700 #{Rails.root + CERTIFICATES_PATH}"
        else
          puts "Directory for certificates at #{Rails.root + options[:certificates_path]} already exists"
        end

      end

      def generate_certificates
        puts "Will generate certificates for #{BANKS.join(', ')} \n"
        BANKS.each do |bank|
          puts "options for #{bank}: #{options[:certificates_subject]}"
          `cd #{Rails.root + options[:certificates_path]} &&
           openssl req -new -nodes -nodes -days 720 -x509 -newkey rsa:1024 -out certificate_for_#{bank}.crt -keyout private_key_for_#{bank}.pem -subj "#{options[:certificates_subject]}" &&
           openssl x509 -x509toreq -in certificate_for_#{bank}.crt -out #{bank}_certificate_request.csr -signkey private_key_for_#{bank}.pem`

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
