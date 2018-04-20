#Based on https://stackoverflow.com/questions/3969475/javascript-pause-settimeout

document.timer = null;

document.Timer = (callback, delay) ->
    this.delay = delay
    
    this.pause = () ->
        if !this.canceled and !this.paused
            window.clearTimeout(this.timerId)
            newdate = new Date()
            this.remaining -= newdate - this.start
            this.paused = true

    this.resume = () ->
        if !this.canceled and this.paused
            this.start = new Date()
            window.clearTimeout(this.timerId)
            this.timerId = window.setTimeout(callback, this.remaining)
            this.paused = false
    
    this.cancel = () ->
        if !this.canceled
            if !this.paused
                window.clearTimeout(this.timerId)
            this.canceled = true

    this.restart = () ->
        this.remaining = this.delay
        this.canceled = false
        this.paused = true
        this.resume()
    
    this.restart()

$(document).on "shown.bs.modal", () ->
    if document.timer
        document.timer.pause()
    
$(document).on "hidden.bs.modal", () ->
    if document.timer
        document.timer.resume()

$(document).on "ajax:before", "#force_ping_form", () ->
    if document.timer
        document.timer.pause()
        $("#refresh_bttn").prop("disabled",true);

$(document).on "ajax:complete", "#force_ping_form", () ->
    if document.timer
        document.timer.resume()
        $("#refresh_bttn").prop("disabled",false);
        
$(document).on "ajax:before", "#refresh_form", () ->
    if document.timer
        document.timer.pause()
        $("#force_ping_bttn").prop("disabled",true);

$(document).on "ajax:complete", "#refresh_form", () ->
    if document.timer
        document.timer.restart()
        $("#force_ping_bttn").prop("disabled",false);
