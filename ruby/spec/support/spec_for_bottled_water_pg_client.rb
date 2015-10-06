RSpec.shared_examples 'a Bottled Water for PostgreSQL client' do

  BOTTLED_WATER_PG_API = [
    :some_api_function_placeholder,
    :another_api_function_placeholder # replace these placeholders by the actual function names
  ]

  describe 'it implements the Bottles Water client API', public: true do

    BOTTLED_WATER_PG_API.each do |function_name|

      it "responds to #{function_name}" #do expect(@subject).to respond_to function_name end

    end
  end
end
