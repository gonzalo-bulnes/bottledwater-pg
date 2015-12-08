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

      attach_function :bw_set_on_insert_row_callback, [:pointer, :pointer], :void

      attach_function :hello_ruby, [:pointer, :pointer], :int

      InsertRowCallback = FFI::Function.new(:int, [:pointer, :uint64, :pointer, :pointer, :size_t, :pointer, :pointer, :size_t, :pointer]) do |returned_type, args_type|
        puts 'hello from the "insert row" callback! (a row must have been inserted!)'
        return 6
      end

      SimpleCallback = FFI::Function.new(:int, [:int]) do |callback_argument|
        callback_argument
      end

      def register_insert_row_callback(callback=InsertRowCallback)
        client_context = self.bw_client_context_new
        bw_set_on_insert_row_callback(client_context, callback)
      end
    end
  end
end
