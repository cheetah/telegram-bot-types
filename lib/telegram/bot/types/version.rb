module Telegram
  module Bot
    module Types
      VERSION = '0.6.1'.freeze

      def self.gem_version
        Gem::Version.new VERSION
      end
    end
  end
end
