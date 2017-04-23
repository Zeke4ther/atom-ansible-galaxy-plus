{CompositeDisposable, Emitter} = require 'atom'
{$, TextEditorView, View} = require 'atom-space-pen-views'
path = require 'path'

class DialogView extends View

  @content: ({prompt} = {}) ->
    @div class: 'tree-view-dialog', =>
      @label prompt, class: 'icon', outlet: 'promptText'
      @subview 'miniEditor', new TextEditorView(mini: true)
      @div class: 'error-message', outlet: 'errorMessage'

  initialize: ({initialPath, iconClass} = {}) ->
    @emitter = new Emitter
    @subscriptions = new CompositeDisposable

    @promptText.addClass(iconClass) if iconClass

    @subscriptions.add atom.commands.add @element,
      'core:confirm': => @onConfirm @miniEditor.getText()
      'core:cancel': => @cancel()
    @miniEditor.on 'blur', => @close()
    @miniEditor.getModel().onDidChange => @showError()
    @miniEditor.getModel().setText initialPath

  attach: ->
    @panel = atom.workspace.addModalPanel item: this.element
    @miniEditor.focus()
    @miniEditor.getModel().scrollToCursorPosition()

  close: ->
    @subscriptions?.dispose()
    @emitter?.dispose()
    panelToDestroy = @panel
    @panel = null
    panelToDestroy?.destroy()
    atom.workspace.getActivePane().activate()

  cancel: ->
    @close()
    $('.tree-view').focus()

  showError: (message='') ->
    @errorMessage.text message
    @flashError() if message

module.exports = DialogView
