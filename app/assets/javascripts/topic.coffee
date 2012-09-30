Wakmj.Topic =
  init : ->
    this.__bindPostReplyBtnClickedEvent()

  __bindPostReplyBtnClickedEvent : ->

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
        , 'html'

$(document).ready ->
  Wakmj.Topic.init()    