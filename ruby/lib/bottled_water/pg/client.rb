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

      # client_context_t -> void
      attach_function :bw_client_context_free, [:pointer], :void

      # client_context_t -> begin_txn_cb -> void
      attach_function :bw_set_begin_txn_callback, [:pointer, :pointer], :void
      # client_context_t -> commit_txn_cb -> void
      attach_function :bw_set_on_commit_txn_callback, [:pointer, :pointer], :void
      # client_context_t -> table_schema_cb -> void
      attach_function :bw_set_on_table_schema_callback, [:pointer, :pointer], :void
      # client_context_t -> insert_row_cb -> void
      attach_function :bw_set_on_insert_row_callback, [:pointer, :pointer], :void
      # client_context_t -> update_row_cb -> void
      attach_function :bw_set_on_update_row_callback, [:pointer, :pointer], :void
      # client_context_t -> delete_row_cb -> void
      attach_function :bw_set_on_delete_row_callback, [:pointer, :pointer], :void
      # client_context_t -> log_cb -> void
      attach_function :bw_set_on_log_callback, [:pointer, :pointer], :void

      # client_context_t -> int
      attach_function :bw_run, [], :int

      InsertRowCallback = FFI::Function.new(:int, [:pointer, :uint64, :pointer, :pointer, :size_t, :pointer, :pointer, :size_t, :pointer]) do |returned_type, args_type|
        puts 'hello from the "insert row" callback! (a row must have been inserted!)'
        return 6
      end

      def register_insert_row_callback(callback=InsertRowCallback)
        client_context = self.bw_client_context_new
        bw_set_on_insert_row_callback(client_context, callback)
      end
    end
  end
end
