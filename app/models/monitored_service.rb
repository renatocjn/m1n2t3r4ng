require 'net/ping'

class MonitoredService < ActiveRecord::Base
    enum service_type: [ :icmp, :tcp, :udp ]
    has_many :monitored_service_logs, dependent: :destroy
    attr_accessor :force_create
    
    validates :service_type, :host, :description, presence: true
    validates :service_type, inclusion: {in: service_types.keys}
    #validates :host, format: {with: /\d{1,3}\.\d{1,3}\.\d{1,3}/, message: "IP inválido"}
    validates :port, presence: true, numericality: {only_integer: true, less_than_or_equal_to: 65535, greater_than: 0}, unless: :icmp?
    validates :port, absence: true, if: :icmp?
    validates :port, uniqueness: {scope: :host, message: "Essa porta já está sendo monitorada"}
    validate :test_single_ping, unless: Proc.new {force_create == "1" or force_create == true or force_create == 1}
    
    def test_single_ping
        errors.add :base, "O serviço aparentemente não está operacional agora" if execute_single_ping.nil?
    end
    
    def execute_single_ping
        if self.icmp?
            p = Net::Ping::External.new self.host
        elsif self.tcp?
            p = Net::Ping::TCP.new self.host, self.port
        elsif self.udp?
            p = Net::Ping::UDP.new self.host, self.port
        end
        
        if p.present? and p.ping?
            p.duration
        else
            nil
        end
    end
    
    def url
        "#{self.service_type}://#{self.host}" + (self.service_type != "icmp" ? ":#{self.port}" : "")
    end
    
    def logs_from_last_day
        self.monitored_service_logs.where("created_at >= ?", 1.day.ago)
    end
    
    def average_from_last_day
        get_log_statistics logs_from_last_day
    end
    
    def logs_from_last_week
        self.monitored_service_logs.where("created_at >= ?", 1.week.ago)
    end
    
    def average_from_last_week
        get_log_statistics logs_from_last_week
    end
    
    def logs_from_last_month
        self.monitored_service_logs.where("created_at >= ?", 1.month.ago)
    end
    
    def average_from_last_month
        get_log_statistics logs_from_last_month
    end
    
    def logs_from_last_year
        self.monitored_service_logs.where("created_at >= ?", 1.year.ago)
    end
    
    def average_from_last_year
        get_log_statistics logs_from_last_year
    end
    
    def latest_delay
        latest_log.present? ? latest_log.first.delay : Float::INFINITY
    end
    
    def latest_delivery_ratio
        latest_log.present? ? latest_log.delivery_ratio : 0
    end
    
    private
    
    def get_log_statistics logs
        delays = Array.new
        del_ratios = Array.new
        logs.each do |l|
            delays << l.delay unless l.delay.nil?
            del_ratios << l.delivery_ratio
        end
        avg_delays = delays.reduce(:+).fdiv(delays.length)
        avg_del_ratios = del_ratios.reduce(:+).fdiv(del_ratios.length)
        return avg_delays*100, avg_del_ratios*100
    end
    
    def latest_log
        self.monitored_service_logs.order(created_at: :desc)
    end
end
