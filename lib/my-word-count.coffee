MyWordCountView = require './my-word-count-view'
{CompositeDisposable} = require 'atom'

module.exports = MyWordCount =
  myWordCountView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @myWordCountView = new MyWordCountView(state.myWordCountViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @myWordCountView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'my-word-count:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @myWordCountView.destroy()

  serialize: ->
    myWordCountViewState: @myWordCountView.serialize()

  toggle: ->
    console.log 'MyWordCount was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      editor = atom.workspace.getActiveTextEditor()
      words = editor.getText().split(/\s+/).length
      @myWordCountView.setCount(words)
      @modalPanel.show()
