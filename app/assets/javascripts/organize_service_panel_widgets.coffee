
window.organize_service_panel_widgets = ->
    $('.device-panel-widget').each ->
        if $(this).find('.service-warning').length != 0
            $('#service-container').prepend(this)
    
    $('.device-panel-widget').each ->
        if $(this).find('.service-down').length != 0
            $('#service-container').prepend(this)
            
    $('.service-warning').each ->
        $(this).parents('.device-services-container').prepend(this)
    
    $('.service-down').each ->
        $(this).parents('.device-services-container').prepend(this)
    
$(document).on "turbolinks:load", () ->
    organize_service_panel_widgets()
    $('.device-panel-widget').fadeIn(1000)