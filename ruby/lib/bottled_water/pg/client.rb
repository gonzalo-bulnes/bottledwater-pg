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

      ffi_lib '/usr/local/lib/libbottledwater.so'

      # void -> client_context_t
      attach_function :bw_client_context_new, [], :pointer

      attach_function :hello_ruby, [:pointer, :pointer], :int

      SimpleCallback = FFI::Function.new(:int, [:int]) do |callback_argument|
        callback_argument
      end
    end
  end
end
