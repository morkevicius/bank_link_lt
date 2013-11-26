require 'rails/generators/base'
module BankLinkLt
  class InstallGenerator < Rails::Generators::Base
    source_root(File.expand_path(File.dirname(__FILE__)))
    #source_root File.expand_path(File.join(File.dirname(__FILE__), 'certificates'))


    INITIALIZER_NAME = 'bank_link_lt.rb'
    CERTIFICATES_PATH = 'certificates/'


    def copy_initializer
      unless File.exist?('config/initializers/' + INITIALIZER_NAME) || File.symlink?('config/initializers/'+INITIALIZER_NAME)
        copy_file 'initializers/' + INITIALIZER_NAME, 'config/initializers/'+INITIALIZER_NAME
      end
    end

    def create_certificates_directory
      unless File.exist?(CERTIFICATES_PATH) || File.symlink?(CERTIFICATES_PATH)
        directory(CERTIFICATES_PATH)

      end

    end

    def generate_certificates
      puts 'should generates certificates now, but ... nothing happens yet :P'
    end

  end
end
