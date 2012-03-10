$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "geopod/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "geopod"
  s.version     = Geopod::VERSION
  s.authors     = ["clmntlxndr"]
  s.email       = ["clmntlxndr@gmail.com"]
  s.homepage    = "http://clmntlxndr.fr"
  s.summary     = "Sync a local copy with Geonames data."
  s.description = "Sync a local copy with Geonames data."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.2"
  s.add_dependency "rubyzip"
  s.add_dependency "grape", '~> 0.1.5'
  
end
