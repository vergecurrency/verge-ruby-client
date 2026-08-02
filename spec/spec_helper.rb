# frozen_string_literal: true

RSpec.configure do |config|
  config.filter_run_excluding live: true unless ENV['LIVE_VERGED'] == '1'
  config.disable_monkey_patching!
  config.order = :random
end
