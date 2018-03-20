require 'net/ping'

class MonitoredService < ActiveRecord::Base
    enum service_type: [ :icmp, :tcp, :udp ]
    belongs_to :device, inverse_of: :monitored_services
    has_many :monitored_service_logs, dependent: :destroy
    attr_accessor :force_create
    delegate :hostname, to: :device
    
    after_initialize do
        self.force_create = 0
    end
    
    validates :device, presence: {message: "Voce deve identificar o dispositivo que dispõe esse serviço"}
    #validates :description, presence: {message: "Voce deve fornecer uma descrição ao serviço"}
    validates :service_type, presence: {message: "Voce deve fornecer o tipo de serviço em questão"}
    validates :service_type, inclusion: {in: service_types.keys, message: "Tipo de serviço inválido"}
    #validates :hostname, format: {with: /\d{1,3}\.\d{1,3}\.\d{1,3}/, message: "IP inválido"}
    validates :port, presence: true, numericality: {only_integer: true, less_than_or_equal_to: 65535, greater_than: 0, message: "Porta de rede inválida"}, unless: :icmp?
    validates :port, absence: {message: "Não é utilizada porta de rede em monitoramentos icmp"}, if: :icmp?
    #validates :port, uniqueness: {scope: :hostname, message: "Esta porta deste dispositivo já está sendo monitorada"}
    validate :test_single_ping, unless: Proc.new {|record| record.force_create == "1" or record.force_create == true or record.force_create == 1}
    validate :uniqueness_of_service
    
    def test_single_ping
        errors.add :base, "O serviço aparentemente não está operacional agora" if execute_single_ping.nil?
    end
    
    def uniqueness_of_service
        errors.add :port, "Este serviço deste dispositivo já está sendo monitorado" if self.device.monitored_services.where(port: self.port).where("id != ?", self.id).any?
    end
    
    def execute_single_ping
        if self.icmp?
            p = Net::Ping::External.new self.hostname, nil, 1
        elsif self.tcp?
            p = Net::Ping::TCP.new self.hostname, self.port, 1
        elsif self.udp?
            p = Net::Ping::UDP.new self.hostname, self.port, 1
        end
        
        if p.present? and p.ping?
            p.duration
        else
            nil
        end
    end
    
    def url
        "#{self.service_type}://#{self.hostname}" + (self.service_type != "icmp" ? ":#{self.port}" : "")
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
    
    def latest_log
        self.monitored_service_logs.order(created_at: :desc).first
    end
    
    def down?
        latest_log.nil? or latest_log.delay.nil?
    end
    
    def warning?
        self.down? or latest_log.delay >= Rails.configuration.warning_delay
    end
    
    def MonitoredService.get_count_of_situations 
        counter = {warning: 0, down: 0, up: 0}
        MonitoredService.all.each do |service|
            if service.down?
                counter[:down] += 1
            elsif service.warning?
                counter[:warning] += 1
            else
                counter[:up] += 1
            end
        end
        return counter
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
end
