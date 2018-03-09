class MonitoredServiceLog < ActiveRecord::Base
  belongs_to :monitored_service
  
  validates :monitored_service, :delivery_ratio, presence: true
  validates :delay, numericality: {greater_than: 0, allow_nil: true}
  validates :delivery_ratio, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
end
