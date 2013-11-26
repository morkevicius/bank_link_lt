require 'rails/generators/base'
module BankLinkLt
  class InstallGenerator < Rails::Generators::Base
    source_root(File.expand_path(File.dirname(__FILE__)))
    #source_root File.expand_path(File.join(File.dirname(__FILE__), 'certificates'))


    INITIALIZER_NAME = 'bank_link_lt.rb'
    CERTIFICATES_PATH = 'certificates/'

    class_option :certificates_path, :type => :string, :default => CERTIFICATES_PATH



    def copy_initializer
      unless File.exist?(Rails.root + 'config/initializers/' + INITIALIZER_NAME) || File.symlink?(Rails.root + 'config/initializers/' + INITIALIZER_NAME)
        puts 'Copying initializer'
        copy_file 'initializers/' + INITIALIZER_NAME, Rails.root + 'config/initializers/' + INITIALIZER_NAME
      else
        puts 'Initializer already exist'
      end
    end

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
      puts "run: rails g bank_link_lt:certificates --certificates_subject ''/C=country_code/L=city/O=company_name/OU=BankLink/CN=www.your_www.lt/emailAddress=your_company_email/'"
    end
    private
#    def Rails.root + options[:certificates_path]
#        (Rails.root + options[:certificates_path]).to_s
#    end
  end
end