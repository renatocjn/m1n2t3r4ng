module DashboardHelper
    def metrics_string service
        latest_log = service.latest_log
        if latest_log.present? and latest_log.delay.present?
          "Atraso: #{number_with_precision (latest_log.delay*1000.0), strip_insignificant_zeros: true} ms"
          #<br>
          #Taxa de entrega: #{number_with_precision (latest_log.delivery_ratio*100.0), precision: 1, strip_insignificant_zeros: true} %"
        else
          "Atraso: - ms"
          #<br> 
          #Taxa de entrega: 0 %"
        end
    end
    
    def service_info_str service
        str = String.new
        if Setting.group_services.present?
            str += service.icmp? ? "ICMP" : "#{service.service_type.upcase}/#{service.port}"
        else
            str += service.url
        end
        str += "<hr class='m-0'>" + simple_format(service.description) if service.description.present?
        return str
    end
    
    def log_ages
        { "Não guardar logs" => 0,
          "1 semana"  =>  1.week.to_i, 
          "2 semanas" =>  2.weeks.to_i, 
          "1 mês"     =>  1.month.to_i, 
          "3 meses"   =>  3.months.to_i, 
          "6 meses"   =>  6.months.to_i, 
          "1 ano"     =>  1.year.to_i, 
          "2 anos"    =>  2.years.to_i, 
          "5 anos"    =>  5.years.to_i, 
          "10 anos"   => 10.years.to_i } 
    end
        
    def stabilization_delays
        { " 1 minuto"  =>  1.minute.to_i,
          " 2 minutos" =>  2.minutes.to_i,
          " 3 minutos" =>  3.minutes.to_i,
          " 4 minutos" =>  4.minutes.to_i,
          " 5 minutos" =>  5.minutes.to_i,
          " 6 minutos" =>  6.minutes.to_i,
          " 7 minutos" =>  7.minutes.to_i,
          " 8 minutos" =>  8.minutes.to_i,
          " 9 minutos" =>  9.minutes.to_i,
          "10 minutos" => 10.minutes.to_i }
    end
end
