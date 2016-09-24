{ RealFodView } = require "./verseoftheday-view"

module.exports =
  statusIcon: null
  view: null
  subscriptions: null
  statusIcon: null

  activate: ->
    @view = new RealFoodView()
    @subscriptions = new CompositeDisposable()
    @subscriptions.add atom.commands.add 'atom-workspace', 'votd:toggle': => @toggle()

  deactivate: ->
    @statusIcon?.destroy()
    @statusIcon = null

  serialize: -> {}

  consumeStatusBar: (statusBar) ->
    @statusIcon = statusBar.addRightTile
      item: @view.getElement()
      priority: -2

  toggle: -> @view.toggle()
