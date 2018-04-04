
if !sessionStorage.getItem("is_audio_enabled")
    sessionStorage.setItem("is_audio_enabled", true)

window.play_sound_if_enabled_and_needed = ->
    if $('.service-down').length != 0 and sessionStorage.getItem("is_audio_enabled") == "true"
        $('#error_audio')[0].currentTime = 0
        $('#error_audio')[0].play()

$(document).on "turbolinks:load", () ->
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