
window.organize_service_panel_widgets = ->
    warnings = $('.service-warning').remove()
    $('#service-container').prepend(warnings)
    
    downs = $('.service-down').remove()
    $('#service-container').prepend(downs)
    
$(document).on "turbolinks:load", () ->
    organize_service_panel_widgets()
    $('.service-panel-widget').fadeIn(1000)