require 'ffi'

require 'bottled_water/pg/configuration'

module BottledWater
  module PG

    # A Ruby client for Bottled Water for PostgreSQL
    #
    # Usage:
    #
    #    client = BottledWater::PG::Client.new do |config|
    #      config.database_url = 'postgres://localhost'
    #    end
    #
    class Client
      extend FFI::Library
      include Configuration

      def initialize
        yield self if block_given?
      end

    end
  end
end
