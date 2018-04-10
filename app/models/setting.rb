# RailsSettings Model
class Setting < RailsSettings::Base
  cache_prefix { 'setting_cache_' }
  source Rails.root.join("config/app.yml")
  namespace Rails.env
end
