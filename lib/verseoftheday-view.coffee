{ CompositeDisposable } = require 'atom'

module.exports =
class RealFoodView
	animating: false
	opened: false
	panel: null
	subscriptions: null
	votdc: null
	signature: ""
	element: null

	constructor: (state) ->
		@subscriptions = new CompositeDisposable

		that = @
		@element = document.createElement 'div'
		@element.classList.add 'votd', 'votd-icon', 'inline-block', 'pointer-cursor'
		@element.addEventListener "click", => that.toggle()

		toggle = document.createElement 'span'
		toggle.classList.add 'icon', 'icon-book'
		@element.appendChild toggle

		@votdc = document.createElement 'div'
		@votdc.classList.add 'votd-view'

		@attach()
		@getLyrics()

		@subscriptions.add atom.tooltips.add @element, title: @signature

	attach: ->
		return if @panel?
		@panel = atom.workspace.addBottomPanel { item: @votdc, visible: false }

	destroy: ->
		@subscriptions.dispose()

		if @panel.isVisible()
			@panel.hide()
		@panel.destroy()

	getLyrics: =>
		fetch("http://www.biblegateway.com").then (data) =>
			console.log(data);
			#@votdc.appendchild data.querySelector ".votd-box p"
			#@votdc.appendChild data.querySelector ".votd-box a:first-child"
			@signature = data.querySelector(".votd-box a:first-child").textContent

	toggle: ->
		if @panel.isVisible()
			@panel.hide()
		else
			@panel.show()
