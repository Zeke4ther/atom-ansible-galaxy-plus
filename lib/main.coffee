{CompositeDisposable} = require 'atom'
ansibleGalaxyExecutor = require './ansible-galaxy-executor'
CreateRoleView = require './create-role-view'

module.exports =

  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add '.tree-view .directory .icon-file-directory, .tree-view .directory .icon-repo', 'ansible-galaxy-plus:init-role', @createRole

  createRole: ({target}) ->
    selectedPath = target.dataset.path
    return unless selectedPath

    dialog = new CreateRoleView selectedPath
    dialog.attach()

    dialog.onDidConfirm (custom) ->
      ansibleGalaxyExecutor.executeInitRole custom.rolePath

  deactivate: ->
    @subscriptions?.dispose()
