# frozen_string_literal: true

require 'tmpdir'

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  minimum_coverage line: 80
end

require 'webmock/rspec'
require 'vcr'

require 'riot_kit'

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |path| require path }

WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  # Requisições HTTP nos specs passam pelo WebMock (sem rede real). O Config padrão usa
  # Logger em $stdout; sem isso todo GET do Http::Client polui o output dos testes.
  config.before do
    RiotKit.config.logger = nil
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed
end
