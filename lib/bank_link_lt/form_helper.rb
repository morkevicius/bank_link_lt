module BankLinkLt::FormHelper
  def payment_form(options = {:request_params_hash => request_params_hash, :payment_url => payment_url, :submit => {:name => submit_name, :render => false}, :form_id => form_id, :form_class => form_class}, &block)
    content_tag :form, :action => options[:payment_url], :method => 'POST', :id => options[:form_id].nil? ? nil : options[:form_id], :class => options[:form_class].nil? ? nil : options[:form_class], :target => '_blank' do
      options[:request_params_hash].each do |key, value|
        concat(tag(:input, :name => key, :value => value, :type => :hidden))
      end
      if !options[:submit].nil? && options[:submit][:render] == true && !options[:submit][:name].nil?
        concat(submit_tag(options[:submit][:name]))
      end
        concat(capture(&block)) if block_given?
    end
  end
end