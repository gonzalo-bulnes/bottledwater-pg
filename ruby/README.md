BottledWater::PG
================

A Ruby client for [Bottled Water for PostgreSQL][bottledwater].

  [bottledwater]: https://github.com/confluentinc/bottledwater-pg

Usage
-----

Install [bottledwater-pg][bottledwater-quickstart], then add the gem to your `Gemfile`:

```ruby
# Gemfile

gem 'bottled_water-pg', '0.1.0' # see semver.org
```

Create a `BottledWater::PG` instance:

```ruby
require 'bottled_water/pg'

client = BottledWater::PG::Client.new

client.configure do |config|
  config.postgres = 'postgres://localhost'
end
```

Then define how you want the changes stream to be processed:

```ruby
client.consume_changes do |transaction|
  transaction.changes.each do |change|
    case change
    when BottledWater::PG::Insert
      puts "Row inserted into table #{change.table}: #{change.row.inspect}" # this is a hash
    when BottledWater::PG::Update
      puts "Row with primary key #{change.key.inspect} in table #{change.table} changed to: #{change.row.inspect}"
    when BottledWater::PG::Delete
      puts "Row with primary key #{change.key.inspect} in table #{change.table} deleted"
    end
  end
  puts "Transaction #{transaction.xid} committed"
end
```

  [bottledwater-quickstart]: https://github.com/confluentinc/bottledwater-pg#quickstart

Development
-----------

RSpec [tags][tags] are used to categorize the spec examples.

Spec examples that are tagged as `public` describe aspects of the gem public API, and MAY be considered as the gem documentation.

The `private` or `protected` specs are written for development purpose only. Because they describe internal behaviour which may change at any moment without notice, they are only executed as a secondary task by the [continuous integration service][travis] and SHOULD be ignored.

Run `rake spec:public` to print the gem public documentation.

  [tags]: https://www.relishapp.com/rspec/rspec-core/v/3-1/docs/command-line/tag-option
  [travis]: https://travis-ci.org/gonzalo-bulnes/simple_token_authentication/builds

License
-------

Copyright © 2015 Gonzalo Bulnes Guilpain
Copyright © 2015 Confluent, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
software except in compliance with the License in the enclosed file called `LICENSE`.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
