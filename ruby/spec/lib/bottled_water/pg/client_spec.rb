require 'spec_helper'

module BottledWater
  module PG
    describe Client do

      let(:client) { Client.new }

      before(:each) do
        @subject = client
      end

      it_behaves_like 'a Bottled Water for PostgreSQL client'

      it 'responds to #postgres', public: true do
        expect(client).to respond_to :postgres
      end

      it 'responds to #database_url', public: true do
        expect(client).to respond_to :database_url
      end

      describe '#database_url' do

        it_behaves_like 'a configuration option', 'database_url'

        it "defaults to 'postgres://localhost'", public: true do
          expect(client.database_url).to eq 'postgres://localhost'
        end
      end

      describe '#initialize' do

        context 'with a block as argument' do

          it 'returns a configured Bottled Water client', public: true do

            subject = Client.new do |config|
              config.postgres = 'postgres://alice:P4ss_w0Rd@localhost'
            end

            expect(subject).to be_instance_of Client
            expect(subject.database_url).to eq 'postgres://alice:P4ss_w0Rd@localhost'
            expect(subject.postgres).to eq 'postgres://alice:P4ss_w0Rd@localhost'
          end
        end
      end

      describe '#postgres' do

        it_behaves_like 'a configuration option', 'postgres'

        it "defaults to 'postgres://localhost'", public: true do
          expect(client.postgres).to eq 'postgres://localhost'
        end
      end

      describe '#register_insert_row_callback', protected: true do

        context 'when called with a FFI::Function instance as argument' do

          it 'registers the function as callabck through bw_set_on_insert_row_callback' do
            callback_function = FFI::Function.new(:void, []) do; end
            context = double()
            allow(subject).to receive(:bw_client_context_new).and_return(context)

            expect(subject).to receive(:bw_set_on_insert_row_callback).with(context, callback_function)
            subject.register_insert_row_callback(callback_function)
          end
        end

        it 'defaults to register InsertRowCallback through bw_set_on_insert_row_callback' do
          context = double()
          allow(subject).to receive(:bw_client_context_new).and_return(context)

          expect(subject).to receive(:bw_set_on_insert_row_callback).with(context, Client::InsertRowCallback)
          subject.register_insert_row_callback
        end
      end
    end
  end
end
