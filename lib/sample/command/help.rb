module Sample
  module Command
    class Help < SlackRubyBot::Commands::Base
      command 'help' do |client, data, match|
        client.say(channel: data.channel, text: help_message)
      end

      def self.help_message()
        text = <<'EOS'
ここにhelpを書く
EOS
      end
    end
  end
end
