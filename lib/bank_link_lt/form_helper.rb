module BankLinkLt::FormHelper
  def payment_form(request_params_hash, url, submit_name)
    content_tag :form, :action => url, :method => 'POST', :target => '_blank' do
      request_params_hash.each do |key, value|
        concat(tag(:input, :name => key, :value => value, :type => :hidden))
      end
      concat(submit_tag(submit_name))
    end
  end
end