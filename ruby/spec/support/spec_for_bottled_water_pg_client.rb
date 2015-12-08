RSpec.shared_examples 'a Bottled Water for PostgreSQL client' do

  BOTTLED_WATER_PG_API = [
    :bw_client_context_new,
    :bw_client_context_free,
    :bw_set_begin_txn_callback,
    :bw_set_on_commit_txn_callback,
    :bw_set_on_table_schema_callback,
    :bw_set_on_insert_row_callback,
    :bw_set_on_update_row_callback,
    :bw_set_on_delete_row_callback,
    :bw_set_on_log_callback,
    :bw_run#, :bw_stop (not yet implemented in Bottled Water)
  ]

  describe 'it implements the Bottles Water client API', public: true do

    BOTTLED_WATER_PG_API.each do |function_name|

      xit "responds to #{function_name}" do expect(@subject).to respond_to function_name end

    end
  end
end
