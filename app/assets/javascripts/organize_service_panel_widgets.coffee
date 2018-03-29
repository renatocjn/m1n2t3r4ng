
window.organize_service_panel_widgets = ->
    $('.device-panel-widget').each ->
        if $(this).find('.service-warning').length != 0
            $('#service-container').prepend(this)
    
    $('.device-panel-widget').each ->
        if $(this).find('.service-down').length != 0
            $('#service-container').prepend(this)
            
    $('.service-warning').each ->
        if $(this).parents('.device-services-container').length == 0
            $(this).parents('#service-container').prepend(this)
        else
            $(this).parents('.device-services-container').prepend(this)
    
    $('.service-down').each ->
        if $(this).parents('.device-services-container').length == 0
            $(this).parents('#service-container').prepend(this)
        else
            $(this).parents('.device-services-container').prepend(this)
    
    if $('.service-down').length != 0
        $('#error_audio')[0].currentTime = 0
        $('#error_audio')[0].play()
    
$(document).on "turbolinks:load", () ->
    organize_service_panel_widgets()
    $('.device-panel-widget').fadeIn(1000)