module.exports =
	statusIcon: null

  activate: ->
	"foo"

  deactivate: ->
    @statusIconTile?.destroy()
    @statusIconTile = null

  consumeStatusBar: (statusIconProvider) ->
    @statusIconTile = new (require './status-icon')(statusIconProvider)
