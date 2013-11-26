require 'rails/generators/base'
#require 'etc'
module BankLinkLt
  class InstallGenerator < Rails::Generators::Base
    source_root(File.expand_path(File.dirname(__FILE__)))
    #source_root File.expand_path(File.join(File.dirname(__FILE__), 'certificates'))


    INITIALIZER_NAME = 'bank_link_lt.rb'
    CERTIFICATES_PATH = 'certificates/'


    def copy_initializer
      unless File.exist?(Rails.root + 'config/initializers/' + INITIALIZER_NAME) || File.symlink?(Rails.root + 'config/initializers/' + INITIALIZER_NAME)
        puts 'Copying initializer'
        copy_file 'initializers/' + INITIALIZER_NAME, Rails.root + 'config/initializers/' + INITIALIZER_NAME
      else
        puts 'Initializer already exist'
      end
    end

    def create_certificates_directory

      unless File.directory?(Rails.root + CERTIFICATES_PATH)|| File.symlink?(Rails.root + CERTIFICATES_PATH)
        puts "Creating directory for certificates at #{Rails.root} #{CERTIFICATES_PATH} "
        Dir.mkdir "#{Rails.root} #{CERTIFICATES_PATH}"
        #system "chmod  700 #{Rails.root + CERTIFICATES_PATH}"
      else
        puts "Directory for certificates at #{Rails.root} #{CERTIFICATES_PATH} already exists"
      end

    end

    def generate_certificates
      puts 'should generates certificates now, but ... nothing happens yet :P'
    end

  end
end
