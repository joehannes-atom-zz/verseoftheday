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

	attach: ->
		return if @panel?
		@panel = atom.workspace.addBottomPanel { item: @votdc, visible: false }

	destroy: ->
		@subscriptions.dispose()

		if @panel.isVisible()
			@panel.hide()
		@panel.destroy()

	getLyrics: =>
		fetch("http://www.biblegateway.com").then((r) => r.blob()).then (data) =>
			file = new FileReader()
			t = document.createElement("div");
			file.onload = () =>
				t.innerHTML = file.result
				@signature = t.querySelector(".votd-box a:first-child").textContent
				@votdc.appendChild t.querySelector ".votd-box p"
				@votdc.appendChild t.querySelector ".votd-box a:first-child"
				@subscriptions.add atom.tooltips.add @element, title: @signature
			file.readAsText data
	toggle: ->
		if @panel.isVisible()
			@panel.hide()
		else
			@panel.show()
