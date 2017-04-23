{CompositeDisposable} = require 'atom'
ansibleGalaxyExecutor = require './ansible-galaxy-executor'
CreateRoleView = require './create-role-view'

module.exports =

  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add '.tree-view .directory .icon-file-directory, .tree-view .directory .icon-repo', 'ansible-galaxy-plus:init-role', @createRole

    roleSkeletonConfigurationKey = 'ansible-galaxy-plus.roleSkeleton.choice'
    @subscriptions.add atom.commands.add 'atom-workspace',
      'ansible-galaxy-plus:skeleton-none': -> atom.config.set roleSkeletonConfigurationKey, 'none'
      'ansible-galaxy-plus:skeleton-a': -> atom.config.set roleSkeletonConfigurationKey, 'skeleton-a'
      'ansible-galaxy-plus:skeleton-b': -> atom.config.set roleSkeletonConfigurationKey, 'skeleton-b'
      'ansible-galaxy-plus:skeleton-c': -> atom.config.set roleSkeletonConfigurationKey, 'skeleton-c'

  createRole: ({target}) ->
    selectedPath = target.dataset.path
    return unless selectedPath

    dialog = new CreateRoleView selectedPath
    dialog.attach()

    dialog.onDidConfirm (custom) ->
      ansibleGalaxyExecutor.executeInitRole custom.rolePath

  deactivate: ->
    @subscriptions?.dispose()
