path = require 'path'

module.exports =

  executeInitRole: (chosenPath) ->

    meta = @makeGalaxyInitRoleMeta chosenPath

    cmd = executeAnsibleGalaxy meta.cmdArgs

    cmd.stdout.on 'data', (data) ->
      atom.notifications.addInfo 'Create role:', detail: data.toString() or '', dismissable: true

    cmd.stderr.on 'data', (data) ->
      console.error "stderr: #{data}"
      atom.notifications.addError 'Error:', detail: data.toString() or '', dismissable: true

    cmd.on 'close', (code) ->
      if code is 0
        atom.notifications.addSuccess 'Role created!', detail: meta.roleName or '', dismissable: false
      else
        atom.notifications.addWarning 'Role created with errors.', detail: meta.roleName or '', dismissable: false

  makeGalaxyInitRoleMeta: (chosenPath) ->
    cmdArgs = ['init']

    roleSkeletonPath = @makeRoleSkeletonPath()
    if roleSkeletonPath? and roleSkeletonPath isnt ''
      cmdArgs.push "--role-skeleton=#{roleSkeletonPath}"

    initPath = path.dirname chosenPath
    cmdArgs.push "--init-path=#{initPath}"

    roleName = path.basename chosenPath
    cmdArgs.push roleName

    meta =
      roleName: roleName
      cmdArgs: cmdArgs

  makeRoleSkeletonPath: ->
    skeletonChoice = atom.config.get 'ansible-galaxy-plus.roleSkeleton.choice'

    if skeletonChoice is 'skeleton-a'
      atom.config.get 'ansible-galaxy-plus.roleSkeleton.pathA'
    else if skeletonChoice is 'skeleton-b'
      atom.config.get 'ansible-galaxy-plus.roleSkeleton.pathB'
    else if skeletonChoice is 'skeleton-c'
      atom.config.get 'ansible-galaxy-plus.roleSkeleton.pathC'
    else
      ''

executeAnsibleGalaxy = (args) ->
  {spawn} = require 'child_process'

  ansibleGalaxyPath = atom.config.get 'ansible-galaxy-plus.ansibleGalaxyPath'

  spawn "#{ansibleGalaxyPath}ansible-galaxy", args
