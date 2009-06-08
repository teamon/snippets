dependency "tlsmail"

###

require 'config/dependencies.rb'
Merb.push_path(:lib, Merb.root / "lib")

Merb::BootLoader.after_app_loads do
  Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
  Merb::Mailer.config = {
    :host => 'smtp.gmail.com',
    :port => '587',
    :user => 'user@gmail.com',
    :pass => '****',
    :auth => :plain
  }
  
  module Merb::Helpers::Form::Builder
    module Errorifier
      def error_messages_for(obj, error_class, build_li, header, before)
        obj ||= @obj
        return "" unless obj.respond_to?(:errors)
        errors = obj.errors.full_messages.uniq
        return "" if errors.empty?
        header_message = header % [errors.size, errors.size == 1 ? "" : "s"]
        markup = %Q{<div class='#{error_class}'>#{header_message}<ul>}
        errors.each {|err| markup << build_li % err}
        markup << %Q{</ul></div>}
      end
    end
  end
end