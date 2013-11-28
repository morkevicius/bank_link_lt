module BankLinkLt::FormHelper
  def payment_form(options = {:request_params_hash => request_params_hash, :payment_url => payment_url, :submit_name => submit_name, :id => id})
    content_tag :form, :action => payment_url, :method => 'POST', :id => id, :target => '_blank' do
      request_params_hash.each do |key, value|
        concat(tag(:input, :name => key, :value => value, :type => :hidden))
      end
      concat(submit_tag(submit_name))
    end
  end
end