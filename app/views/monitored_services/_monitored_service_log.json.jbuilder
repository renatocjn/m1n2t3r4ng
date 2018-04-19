json.extract! monitored_service_log, :id, :delay, :delivery_ratio, :created_at
json.url monitored_service_url(monitored_service_log, format: :json)
