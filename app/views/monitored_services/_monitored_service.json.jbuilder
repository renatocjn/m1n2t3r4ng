json.extract! monitored_service, :id, :service_type, :hostname, :port, :description, :created_at, :updated_at
json.url monitored_service_url(monitored_service, format: :json)
