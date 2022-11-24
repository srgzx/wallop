$ ->

  bitrate = ->
    localStorage.bitrate || "3000k"

  resolution = ->
    localStorage.resolution || "1280x720"

  profile = ->
    localStorage.profile || "mobile"
    
  deint = ->
    localStorage.deint || "0"

  loadSettings = ->
    $('.resolution-setting').each (i, e)  =>
      if $(e).val() == resolution()
        $(e).attr('checked', 'checked')

    $('.bitrate-setting').each (i, e)  =>
      if $(e).val() == bitrate()
        $(e).attr('checked', 'checked')

    $('.profile-setting').each (i, e)  =>
      if $(e).val() == profile()
        $(e).attr('checked', 'checked')
        
    $('.deint-setting').each (i, e)  =>
      if $(e).val() == deint()
        $(e).attr('checked', 'checked')

  $('.resolution-setting').change ->
    self = $(this)
    localStorage.resolution = self.val()

  $('.bitrate-setting').change ->
    self = $(this)
    localStorage.bitrate = self.val()

  $('.profile-setting').change ->
    self = $(this)
    localStorage.profile = self.val()

  $('.deint-setting').change ->
    self = $(this)
    localStorage.deint = self.val()



  loadSettings()
