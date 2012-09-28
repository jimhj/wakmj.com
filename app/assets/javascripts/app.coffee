# = require jquery
# = require jquery_ujs

Wakmj = window.Wakmj = {}

Wakmj.CommonEvents = 
  init : ->
    this.__bindFormSubmitEvent()

  __bindFormSubmitEvent : ->
    $('.form_panel a.submit_btn, form a.submit_btn').click ->
      $form = $(this).parents('form')
      $form[0].submit()

$(document).ready ->
  Wakmj.CommonEvents.init()    