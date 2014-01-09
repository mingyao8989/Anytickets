$ ->
  $('.pulldown-menu').each ->
    $this = $(@)

    $this.find('.pulldown-item').css('min-width', $this.width())