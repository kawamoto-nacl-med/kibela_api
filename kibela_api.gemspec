require_relative "lib/kibela_api/version"

Gem::Specification.new do |spec|
  spec.name = "kibela_api"
  spec.version = KibelaApi::VERSION
  spec.authors = ["satoshi kawamoto"]
  spec.email = ["satoshi.kawamoto@nacl-med.co.jp"]

  spec.summary = ""
  spec.description = ""
  spec.homepage = ""
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = ""

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) {
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
end
