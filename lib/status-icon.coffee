{CompositeDisposable} = require 'atom'
{$, View} = require 'atom-space-pen-views'

VerseOfTheDayView = require './view'

module.exports =
class StatusIcon extends View
  @content: ->
	@div class: 'votd votd-icon status-bar', tabindex: -1, =>
      @i class: "icon icon-book", click: 'toggle'

  initialize: (@statusIconProvider) ->
    @subscriptions =  new CompositeDisposable()

    @subscriptions.add atom.commands.add 'atom-workspace', 'votd:toggle': => @toggle()

    @attach()
	@view = new VerseOfTheDayView()

  attach: ->
    @tile = @statusIconProvider.addRightTile { item: this, priority: -2 }

  destroy: ->
	@tile.destroy()
	@subscriptions.dispose()

  toggle: ->
	@view.toggle()
