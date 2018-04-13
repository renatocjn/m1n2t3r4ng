
if !sessionStorage.getItem("is_audio_enabled")
    sessionStorage.setItem("is_audio_enabled", true)

if !sessionStorage.getItem("down_count")
    sessionStorage.setItem("down_count", 0)

window.play_sound_if_enabled_and_needed = ->
    new_down_count = $('.service-down').length
    if sessionStorage.getItem("is_audio_enabled") == "true"
        if new_down_count > sessionStorage.getItem("down_count")
            $('#down_service_audio')[0].currentTime = 0
            $('#down_service_audio')[0].play()
        else if new_down_count < sessionStorage.getItem("down_count")
            $('#up_service_audio')[0].currentTime = 0
            $('#up_service_audio')[0].play()
    sessionStorage.setItem("down_count", new_down_count)

$(document).on "turbolinks:load", ->
    if sessionStorage.getItem("is_audio_enabled") == "true"
        $("#unmute-audio-bttn").hide()
    else
        $("#mute-audio-bttn").hide()
    play_sound_if_enabled_and_needed()
        
    $("#mute-audio-bttn").click ->
        $(this).hide().tooltip("hide")
        $("#unmute-audio-bttn").show()
        document.play_audio = false
        sessionStorage.setItem("is_audio_enabled", false)
        
    $("#unmute-audio-bttn").click ->
        $(this).hide().tooltip("hide")
        $("#mute-audio-bttn").show()
        sessionStorage.setItem("is_audio_enabled", true)