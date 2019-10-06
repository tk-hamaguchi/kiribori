# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kiribori/version'

Gem::Specification.new do |spec|
  spec.name          = 'kiribori'
  spec.version       = Kiribori::VERSION
  spec.authors       = ['Takahiro HAMAGUCHI']
  spec.email         = ['tk.hamaguchi@gmail.com']

  spec.summary       = 'Rails template generator'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/tk-hamaguchi/kiribori'
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/tk-hamaguchi/kiribori'
  spec.metadata['changelog_uri'] = 'https://github.com/tk-hamaguchi/kiribori'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib config templates]

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_runtime_dependency 'rack', '~> 2.0.7'
  spec.add_runtime_dependency 'thor', '~> 0.20.3'
end
