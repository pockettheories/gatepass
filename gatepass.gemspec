require_relative "lib/gatepass/version"

Gem::Specification.new do |spec|
  spec.name        = "gatepass"
  spec.version     = Gatepass::VERSION
  spec.authors     = ["Nitin Reddy"]
  spec.email       = ["82951937+nitredd@users.noreply.github.com"]
  spec.homepage    = "https://github.com/pockettheories/gatepass"
  spec.summary     = "An ActiveDirectory and local user authentication plugin for Rails"
  spec.description = "This Rails plugin enables you to authenticate users against the local database as well as against an ActiveDirectory server"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/pockettheories/gatepass"
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.6"
  spec.add_dependency "bcrypt", ">= 3.1.19"
  spec.add_dependency "net-ldap", ">= 0.18.0"
end
