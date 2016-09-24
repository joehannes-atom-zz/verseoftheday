{Task, CompositeDisposable, Emitter} = require 'atom'
{$, View} = require 'atom-space-pen-views'

lastActiveElement = null

module.exports =
class RealFoodView extends View
  animating: false
  id: ''
  maximized: false
  opened: false
  pwd: ''
  windowHeight: $(window).height()
  rowHeight: 20
  tabView: false

  @content: ->
    @div class: 'votd votd-view', outlet: 'VotdView', =>
      @div class: 'panel-divider', outlet: 'panelDivider'
      @div class: 'btn-toolbar', outlet:'toolbar', =>
        @button outlet: 'closeBtn', class: 'btn inline-block-tight right', click: 'destroy', =>
          @span class: 'icon icon-x'
	  @div class: 'votd-content', outlet:'votdc'

  initialize: () ->
    @subscriptions = new CompositeDisposable
    @emitter = new Emitter

    @subscriptions.add atom.tooltips.add @closeBtn,
      title: 'Close'

    @prevHeight = atom.config.get('verseoftheday.style.defaultPanelHeight')
    if @prevHeight.indexOf('%') > 0
      percent = Math.abs(Math.min(parseFloat(@prevHeight) / 100.0, 1))
      bottomHeight = $('atom-panel.bottom').children(".votd-view").height() or 0
      @prevHeight = percent * ($('.item-views').height() + bottomHeight)

	@getLyrics()
    @setAnimationSpeed()

  attach: ->
    return if @panel?
    @panel = atom.workspace.addBottomPanel(item: this, visible: false)

  setAnimationSpeed: =>
    @animationSpeed = atom.config.get('verseoftheday.style.animationSpeed')
    @animationSpeed = 100 if @animationSpeed is 0

	@votdc.css 'transition', "height #{0.25 / @animationSpeed}s linear"

  destroy: ->
    @subscriptions.dispose()
    @statusIcon.destroy()

    if @panel.isVisible()
      @hide()
      @onTransitionEnd => @panel.destroy()
    else
      @panel.destroy()

    if @statusIcon and @statusIcon.parentNode
      @statusIcon.parentNode.removeChild(@statusIcon)

  getLyrics: =>
	$.get "http://www.biblegateway.com", (data) =>
		console.log(data);
		@votdc.appendchild $(data).find(".votd-box p")
		@votdc.appendChild $(data).find(".votd-box a:first-child")

  open: =>
    @onTransitionEnd =>
      if not @opened
        @opened = true
        @displayVotd()

    @panel.show()
	@votdc.height 0
    @animating = true
    @votdc.height if @maximized then @maxHeight else @prevHeight

  hide: =>
    @onTransitionEnd =>
      @panel.hide()

    @votdc.height if @maximized then @maxHeight else @prevHeight
    @animating = true
    @votdc.height 0

  toggle: ->
    return if @animating

    if @panel.isVisible()
      @hide()
    else
      @open()

  onTransitionEnd: (callback) ->
    @votdc.one 'webkitTransitionEnd', =>
      callback()
      @animating = false

  emit: (event, data) ->
    @emitter.emit event, data

  isAnimating: ->
    return @animating
