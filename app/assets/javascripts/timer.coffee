#Based on https://stackoverflow.com/questions/3969475/javascript-pause-settimeout

class @Timer
    constructor: (@callback, @delay) ->
        @restart()
    
    pause: ->
        if not @canceled and not @paused
            clearTimeout(@timerId)
            @remaining -= new Date() - @start
            @paused = yes

    resume: ->
        if not @canceled and @paused
            @start = new Date()
            clearTimeout(@timerId)
            @timerId = setTimeout(@callback, @remaining)
            @paused = no
    
    cancel: ->
        unless @canceled
            clearTimeout(@timerId) unless @paused
            @canceled = yes

    restart: ->
        @remaining = @delay
        @canceled = no
        @paused = yes
        @resume()

$(document).on "shown.bs.modal ajax:before", ->
    @timer.pause() if @timer?
    
$(document).on "hidden.bs.modal ajax:complete", ->
    @timer.resume() if @timer?

$(document).on "ajax:before", "#force_ping_form, #refresh_form", ->
    $(".service-actions .btn, .service-actions a, #force_ping_bttn, #refresh_bttn").not($(this).find(".btn, a")).prop("disabled", true)

$(document).on "ajax:complete", "#force_ping_form, #refresh_form", ->
    $(".service-actions .btn, .service-actions a, #force_ping_bttn, #refresh_bttn").not($(this).find(".btn, a")).prop("disabled", false)
