# = require jquery
# = require jquery_ujs
# = require lib/jquery.timeago
# = require lib/jquery.timeago.zh-CN
# = require_self

Wakmj = window.Wakmj = {}

Wakmj.CommonEvents = 
  init : ->
    this.__bindFormSubmitEvent()
    this.__bindLikeStuffEvent()
    this.__bindJqueryTimeago()
    this.__searchTvDrama()

  __bindJqueryTimeago : ->
    $('span.timeago').timeago()    

  __bindFormSubmitEvent : ->

    $('.form_panel a.submit_btn, form a.submit_btn').click ->
      $form = $(this).parents('form')
      $form[0].submit() if $form.length > 0
      
    $('.form_panel input:last').keyup (e) ->
      $form = $(this).parents('form')
      if e.keyCode == 13 && $form.length > 0 
        # if $form.is('.search_panel')
        #   $form[0].submit() if $.trim($(this).val()).length > 0 
        # else
        $form[0].submit()


  __bindLikeStuffEvent : ->
    $('a.like_it').click ->
      $this = $(this)
      likeable_type = $(this).data('likeable_type')
      likeable_id = $(this).data('likeable_id')
      if $(this).data('liked')
        # TODO: unlike.
      else
        $.post '/likes', { likeable_type : likeable_type, likeable_id : likeable_id }, (res) ->
          if res.success
            $this.data('liked', 'true').html("已喜欢<span>(#{res.likes_count})</span>")
        , 'json'

  __searchTvDrama : ->
    $('.search_panel input').focus ->
      if $(this).val() == $(this).attr('default_text')
        $(this).val('')
    .blur ->
      if $.trim($(this).val()).length == 0
        $(this).val $(this).attr('default_text')

$(document).ready ->
  Wakmj.CommonEvents.init()    