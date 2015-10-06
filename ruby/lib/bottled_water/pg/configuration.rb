module BottledWater
  module PG
    module Configuration

      attr_accessor :database_url

      # Default configuration

      def database_url
        @database_url || 'postgres://localhost'
      end

      alias :postgres :database_url
      alias :postgres= :database_url=

    end
  end
end
