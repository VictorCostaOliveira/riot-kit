# frozen_string_literal: true

require_relative 'lib/riot_kit/version'

Gem::Specification.new do |spec|
  spec.name = 'riot_kit'
  spec.version = RiotKit::VERSION
  spec.authors = ['Victor']
  spec.summary = 'League of Legends / Riot API Ruby toolkit (pure Ruby, no Rails).'
  spec.description = <<~DESC
    RiotKit exposes Riot Games REST API clients, plain-Ruby domain models, Data Dragon
    helpers, and optional fluent facades. Zero Rails dependency.
  DESC
  spec.homepage = 'https://github.com/VictorCostaOliveira/riot-kit'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    rb_json_txt = Dir.glob('lib/**/*').select { |path| File.file?(path) }
    rake_tasks = Dir.glob('lib/tasks/**/*.rake')
    rb_json_txt.concat(rake_tasks).push('riot_kit.gemspec', 'README.md', 'README.pt-br.md', 'INTEGRATION.md', 'INTEGRATION.pt-br.md', 'CHANGELOG.md', 'LICENSE.txt').uniq
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '~> 0.22'
  spec.add_dependency 'logger', '>= 1.6'

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'rubocop', '~> 1.69'
  spec.add_development_dependency 'rubocop-rspec', '~> 3.2'
  spec.add_development_dependency 'simplecov', '~> 0.22'
  spec.add_development_dependency 'vcr', '~> 6.3'
  spec.add_development_dependency 'webmock', '~> 3.24'
end
