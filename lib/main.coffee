{CompositeDisposable} = require 'atom'
ansibleGalaxyExecutor = require './ansible-galaxy-executor'
CreateRoleView = require './create-role-view'

module.exports =

  roleSkeletonConfigurationKey: 'ansible-galaxy-plus.roleSkeleton.choice'
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add '.tree-view .directory .icon-file-directory, .tree-view .directory .icon-repo', 'ansible-galaxy-plus:init-role', @createRole

    @subscriptions.add atom.commands.add 'atom-workspace',
      'ansible-galaxy-plus:skeleton-none': => @changeSkeletonPath 'none'
      'ansible-galaxy-plus:skeleton-a': => @changeSkeletonPath 'skeleton-a'
      'ansible-galaxy-plus:skeleton-b': => @changeSkeletonPath 'skeleton-b'
      'ansible-galaxy-plus:skeleton-c': => @changeSkeletonPath 'skeleton-c'

  createRole: ({target}) ->
    selectedPath = target.dataset.path
    return unless selectedPath

    dialog = new CreateRoleView selectedPath
    dialog.attach()

    dialog.onDidConfirm (custom) ->
      ansibleGalaxyExecutor.executeInitRole custom.rolePath

  changeSkeletonPath: (next) ->
    previous = atom.config.get @roleSkeletonConfigurationKey
    atom.config.set @roleSkeletonConfigurationKey, next
    atom.notifications.addInfo 'Ansible Galaxy Skeleton', detail: "Change from #{previous} to #{next}.", dismissable: false

  deactivate: ->
    @subscriptions?.dispose()
