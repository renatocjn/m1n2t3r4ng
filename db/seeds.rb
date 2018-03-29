# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


ActiveRecord::Base.transaction do
    device = Device.create! name: "RB CORPORATE", hostname: "corporate.casebrastecnologia.com.br"
    device.monitored_services.create! name: "Winbox", port: 30000, service_type: :tcp, force_create: true
    device.monitored_services.create! name: "Câmeras", port: 85, service_type: :tcp, force_create: true
    device.monitored_services.create! name: "Ping", service_type: :icmp, force_create: true
    
    device = Device.create! name: "RB ALVORADA", hostname: "alvorada.casebrastecnologia.com.br"
    device.monitored_services.create! name: "Winbox", port: 30000, service_type: :tcp, force_create: true
    
    device = Device.create! name: "RB 7 DE ABRIL", hostname: "7deabril.casebrastecnologia.com.br"
    device.monitored_services.create! name: "Winbox", port: 30000, service_type: :tcp, force_create: true
    
    device = Device.create! name: "RB BUCATINNI", hostname: "bucatinni.casebrastecnologia.com.br"
    device.monitored_services.create! name: "Winbox", port: 30000, service_type: :tcp, force_create: true
    
    device = Device.create! name: "RB PERBOYRE", hostname: "perboyre.casebrastecnologia.com.br"
    device.monitored_services.create! name: "Winbox", port: 30000, service_type: :tcp, force_create: true
    
    device = Device.create! name: "RB MARANGUAPE", hostname: "maranguape.casebrastecnologia.com.br"
    device.monitored_services.create! name: "Winbox", port: 30000, service_type: :tcp, force_create: true
    
    device = Device.create! name: "RB CALL RECIFE", hostname: "callrecife.casebrastecnologia.com.br"
    device.monitored_services.create! name: "Winbox", port: 30000, service_type: :tcp, force_create: true
    
    device = Device.create! name: "RB CONJ CEARÁ", hostname: "conjceara.casebrastecnologia.com.br"
    device.monitored_services.create! name: "Winbox", port: 30000, service_type: :tcp, force_create: true
    
    device = Device.create! name: "RB MONTESE", hostname: "montese.casebrastecnologia.com.br"
    device.monitored_services.create! name: "Winbox", port: 30000, service_type: :tcp, force_create: true
end
