
$(document).on "turbolinks:load ready", () ->
    $('[data-toggle="tooltip"]').tooltip()
    $('[data-toggle="popover"]').popover()
    
    $('#notification-modal').modal('show')
    
    