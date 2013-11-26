require 'rails/generators/base'
#require 'etc'
module BankLinkLt
  class InstallGenerator < Rails::Generators::Base
    source_root(File.expand_path(File.dirname(__FILE__)))
    #source_root File.expand_path(File.join(File.dirname(__FILE__), 'certificates'))


    INITIALIZER_NAME = 'bank_link_lt.rb'
    class_option :certificates_path, :type => :string, :default => CERTIFICATES_PATH
    CERTIFICATES_PATH = 'certificates/'
    CERTIFICATES_FULL_PATH = Rails.root + options[:certificates_subject]



    def copy_initializer
      unless File.exist?(Rails.root + 'config/initializers/' + INITIALIZER_NAME) || File.symlink?(Rails.root + 'config/initializers/' + INITIALIZER_NAME)
        puts 'Copying initializer'
        copy_file 'initializers/' + INITIALIZER_NAME, Rails.root + 'config/initializers/' + INITIALIZER_NAME
      else
        puts 'Initializer already exist'
      end
    end

    def create_certificates_directory

      unless File.directory?(CERTIFICATES_FULL_PATH)|| File.symlink?(CERTIFICATES_FULL_PATH)
        puts "Creating directory for certificates at #{Rails.root} #{CERTIFICATES_PATH} "
        Dir.mkdir "#{CERTIFICATES_FULL_PATH}"
        #system "chmod  700 #{Rails.root + CERTIFICATES_PATH}"
      else
        puts "Directory for certificates at #{CERTIFICATES_FULL_PATH} already exists"
      end

    end

    def generate_certificates
      puts "run 'rails g bank_link_lt:certificates'  "
    end

  end
end
