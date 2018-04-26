
$(document).on "turbolinks:load ready", () ->
    $('[data-toggle="tooltip"]').tooltip()
    $('[data-toggle="popover"]').popover()
    
    $('#notification-modal').modal('show')
    
$(document).on "ajax:success", "#update_settings_form", ->
    $("#settingsModal").modal('hide')