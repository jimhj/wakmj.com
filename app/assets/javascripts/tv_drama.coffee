Wakmj.TvDrama = 
  init : ->
    this.__bindSwitchTabEvent()
    this.__setPaginateToAjax()

  __bindSwitchTabEvent : ->
    $('.nav_tabs .tab').click ->
      $this = $(this)
      $this.addClass('active')
      $this.parents('.nav_tabs').find('.tab').not($this).removeClass('active')

      if $this.is('.topics')
        $('.topics_panel').show()
        $('.downloads_panel, .related_dramas_panel').hide()
      else if $this.is('.downloads')
        $('.downloads_panel').show()
        $('.topics_panel, .related_dramas_panel').hide()
      else if $this.is('.related_dramas')
        $('.related_dramas_panel').show()
        $('.topics_panel, .downloads_panel').hide()

  __setPaginateToAjax : ->
    $('.digg_pagination a').attr('data-remote', true)

    $('body').on 'click', '.digg_pagination a, .res_seasons a',  -> 
      $this = $(this)

      # if $this.closest('.res_seasons').length > 0
      #   $this.addClass('active')
      #   $this.closest('.res_seasons').find('a').not($this).removeClass('active')
      $list_panel = $this.parents('.list_container')
      if $list_panel.is('.downloads_panel')
        params = { to : 'downloads' }
      else if $list_panel.is('.topics_panel')
        params = { to : 'topics' }

      $loading = $('<div class="blank_notice"><img src="/assets/loading.gif" /></div>')

      $save = $list_panel.find('.notice_ment').detach()

      $list_panel.empty().append($save, $loading)

      # _url = $this.attr('href').split('&')[0]
      _url = $this.attr('href')
      $.get _url, params, (res) ->
        $list_panel.empty().append $save, $(res)
      , 'json'
      return false;
      # if $this.text() == 1



$(document).ready ->
  Wakmj.TvDrama.init()     