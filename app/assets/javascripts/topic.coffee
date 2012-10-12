Wakmj.Topic =
  init : ->
    this.__bindPostReplyBtnClickedEvent()

  __bindPostReplyBtnClickedEvent : ->

    $('a.at_user').click ->
      $this = $(this)
      at_str = "@#{$this.data('user_login')}   "
      $textarea = $('.post_reply_panel textarea')
      reserve_str = $textarea.val()
      at_str = "\n#{at_str}" if $.trim(reserve_str).length != 0        
      $textarea.val(reserve_str + at_str).focus()


    $('a.replyBtn').click ->
      $this = $(this)
      $textarea = $this.parents('.input_panel').find('textarea')
      topic_id = $textarea.data('topic_id')
      val = $textarea.val()
      $reply_panel = $('.reply_list')

      if $.trim(val).length > 0
        url = "/topics/#{topic_id}/replies"
        $.post url, { content : val }, (res) ->
          $reply_panel.find('.blank_notice').remove()
          $reply_panel.append(res)
          $textarea.val('')
        , 'html'

$(document).ready ->
  Wakmj.Topic.init()    