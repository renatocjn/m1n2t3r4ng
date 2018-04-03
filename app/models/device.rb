class Device < ActiveRecord::Base
    has_many :monitored_services, dependent: :destroy, inverse_of: :device
    has_many :monitored_service_logs, through: :monitored_services
    
    validates :name, presence: {message: "Você deve fornecer um nome ao dispositivo"}
    validates :name, length: {maximum: 14, message: "O nome do dispositivo deve ser menor que 14 caracteres"}
    validates :hostname, presence: {message: "Voce deve fornecer um endereço IP ou nome DNS do dispositivo"},
                         uniqueness: {message: "Este dispositivo já está sendo monitorado"}
    #validates :description, presence: {message: "Voce deve fornecer uma descrição ao serviço"}
    
    def to_s 
        name
    end
end
