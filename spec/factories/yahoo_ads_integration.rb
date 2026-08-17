# The canonical factory lives in lib/ so the engine can ship it as testing
# support (loaded by the engine's own spec_helper via
# `require 'spree_yahoo_ads/factories'`).
#
# The main app's spec/rails_helper.rb only globs
# `engines/*/spec/factories/**/*.rb`, so we re-load the canonical definition
# here to register `:yahoo_ads_integration` when the full suite (CI) runs.
# The two paths are loaded by disjoint helpers, so there is no
# double-registration.
load File.expand_path(
  '../../../lib/spree_yahoo_ads/testing_support/factories/yahoo_ads_integration.rb',
  __FILE__
)
