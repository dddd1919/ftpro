# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "ftpro"
  spec.version       = '0.0.1'
  spec.authors       = ["dddd1919"]
  spec.email         = ["dingrank@gmail.com"]
  spec.summary       = %q{"The enhanced version of net/ftp"}
  spec.description   = %q{"Provide all net/ftp method and some additional functionality"}
  spec.homepage      = "https://github.com/dddd1919/ftpro"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
