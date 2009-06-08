require 'rubygems'
require 'xmpp4r-simple'

class Jubot
  
  class << self
    include Jabber
  
    def configure(opts = {})
      @@logger = opts[:logger] || Class.new { def self.<<(msg) STDOUT.puts msg end }
      @@id = opts[:id]
      @@password = opts[:password]
      @@status = opts[:status]
    end
  
    def start!
      @@conn = Simple.new(@@id, @@password)
      @@conn.send! Presence.new(:chat, @@status, 5)
      log("Bot started")
      
      Thread.new do
        loop do
          if @@conn.received_messages?
            @@conn.received_messages do |message|
              if message.type == :chat
                log("#{message.from} \033[0;32m>>\033[0m  #{message.body}")
                # Merb.logger.d message.from.to_s
                send_message(message.from.to_s, parse_message(message)) 
              end
            end
          end
          sleep 0.1
        end
      end
      
    end
  
    def send_message(recipients, msg)
      Thread.new { 
        log("#{recipients} \033[0;31m<<\033[0m #{msg}")
        recipients = [recipients] unless recipients.is_a?(Array)
        recipients.each do |recipient|
          @@conn.deliver(recipient, msg) 
        end
      }.join
    end
  
    def log(message)
      @@logger << "#{Time.now} #{message}"
    end
    
    def started?
      defined?(@@conn) && @@conn
    end
  
    def parse_message(message)
      case message.body
      when /^help/
        <<-HELP
        Bot usage:
          reply [entry_id] [text]    - Add comment to entry
        HELP
      when /^reply (\d+) (.+)/
        "entry_id=#{$1}, text=#{$2}"
      else
        "I don`t understand. Type 'help' for usage."
      end
    end
    
  end
end


###

  require "lib/jubot"
  Jubot.configure :id => "user@jabber.org", :password => "pass", :status => "Hello", :logger => Merb.logger
  Jubot.start!