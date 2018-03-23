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
end
