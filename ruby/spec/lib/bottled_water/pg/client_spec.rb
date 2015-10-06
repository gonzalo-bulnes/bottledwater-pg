require 'spec_helper'

module BottledWater
  module PG
    describe Client do

      let(:client) { Client.new }

      it 'responds to #postgres', public: true do
        expect(client).to respond_to :postgres
      end

      it 'responds to #database_url', public: true do
        expect(client).to respond_to :database_url
      end

      describe '#database_url' do

        before(:each) do
          @subject = client
        end

        it_behaves_like 'a configuration option', 'database_url'

        it "defaults to 'postgres://localhost'", public: true do
          expect(client.database_url).to eq 'postgres://localhost'
        end
      end

      describe '#postgres' do

        before(:each) do
          @subject = client
        end

        it_behaves_like 'a configuration option', 'database_url'

        it "defaults to 'postgres://localhost'", public: true do
          expect(client.postgres).to eq 'postgres://localhost'
        end
      end
    end
  end
end
