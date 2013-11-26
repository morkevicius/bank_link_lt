require 'bank_link_lt/form_helper'
module BankLinkLt
  class Railtie < Rails::Railtie
    initializer "BankLinkLt.form_helper" do
      ActionView::Base.send :include, FormHelper
    end
  end


end
#class Hash
#  def deep_transform_keys(&block)
#    result = {}
#    each do |key, value|
#      result[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys(&block) : value
#    end
#    result
#  end
#end
