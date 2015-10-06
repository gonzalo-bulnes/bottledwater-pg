$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bottled_water/pg/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name          = "bottled_water-pg"
  gem.version       = BottledWater::PG::VERSION
  gem.authors       = ["Gonzalo Bulnes Guilpain"]
  gem.email         = ["gon.bulnes@gmail.com"]
  gem.summary       = %q{A Ruby client for Bottled Water for PostgreSQL.}
  gem.homepage      = "https://github.com/gonzalo-bulnes/bottledwater-pg"
  gem.license       = "Apache-2.0" # see https://spdx.org/licenses

  gem.files = Dir["{doc,lib}/**/*", "Gemfile", "README.md"]
end
