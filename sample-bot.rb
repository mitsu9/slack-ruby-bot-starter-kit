require 'slack-ruby-bot'
require 'dotenv'

require_relative 'lib/Sample'

Dotenv.load

class SampleBot < SlackRubyBot::Bot
  def initialize
    @flag_int = false
    @pid_file = "./sample-bot-daemon.pid"
  end

  def run
    begin
      daemonize()
      set_trap()

      SlackRubyBot.configure do |config|
        config.logger = logger
        config.logger.level = Logger::INFO
      end

      self.class.superclass.run()
    rescue => e
      logger.error "[#{self.class.name}.run] #{e} backtrace: #{e.backtrace}"
      exit 1
    end
  end

  private

  def daemonize
    begin
      Process.daemon(true, true)
      open(@pid_file, 'w') {|f| f << Process.pid} if @pid_file
    rescue => e
      logger.error "[#{self.class.name}.daemonize] #{e} backtrace: #{e.backtrace}"
      exit 1
    end
  end

  def set_trap
    begin
      Signal.trap(:INT)  {@flag_int = true}  # SIGINT  捕獲
      Signal.trap(:TERM) {@flag_int = true}  # SIGTERM 捕獲
    rescue => e
      logger.error "[#{self.class.name}.set_trap] #{e} backtrace: #{e.backtrace}"
      exit 1
    end
  end

  def logger
    self.class.logger
  end

  def self.logger
    @@logger ||= Logger.new(File.expand_path(File.dirname(__FILE__) + "/log/sample-bot.log"), "weekly")
  end
end


begin
  SampleBot.new.run
rescue Exception => e
  SampleBot.logger.error "#{e.inspect} backtrace: #{e.backtrace}"
  raise e
end
