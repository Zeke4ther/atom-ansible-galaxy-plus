path = require 'path'

module.exports =

  executeInitRole: (chosenPath) ->

    meta = @makeGalaxyInitRoleMeta chosenPath

    cmd = executeAnsibleGalaxy meta.cmdArgs

    cmd.stdout.on 'data', (data) ->
      atom.notifications.addInfo 'Create role:', detail: data.toString() or '', dismissable: false

    cmd.stderr.on 'data', (data) ->
      console.error data.toString()
      atom.notifications.addError 'Error:', detail: data.toString() or '', dismissable: true

    cmd.on 'close', (code) =>
      description = @makeDescriptionMessage meta

      if code is 0
        atom.notifications.addSuccess 'Role created!', description: description, dismissable: true
      else
        atom.notifications.addWarning 'Role created with errors.', description: description, dismissable: true

  makeDescriptionMessage: (meta) ->
    descriptionLines = [
      "Role name: **#{meta.roleName}**"
      ""
      "- skeleton: _#{meta.skeletonType}_"
    ]
    if meta.skeletonType isnt 'none'
      descriptionLines.push "- `#{meta.skeletonPath}`"

    descriptionLines.join '\n'

  makeGalaxyInitRoleMeta: (chosenPath) ->
    cmdArgs = ['init']

    skeletonChoice = atom.config.get 'ansible-galaxy-plus.roleSkeleton.choice'
    roleSkeletonPath = @makeRoleSkeletonPath skeletonChoice
    if roleSkeletonPath? and roleSkeletonPath isnt ''
      cmdArgs.push "--role-skeleton=#{roleSkeletonPath}"

    initPath = path.dirname chosenPath
    cmdArgs.push "--init-path=#{initPath}"

    roleName = path.basename chosenPath
    cmdArgs.push roleName

    meta =
      roleName: roleName
      cmdArgs: cmdArgs
      skeletonType: skeletonChoice
      skeletonPath: roleSkeletonPath

  makeRoleSkeletonPath: (skeletonChoice) ->
    if skeletonChoice is 'none' or skeletonChoice is ''
      ''
    else
      atom.config.get "ansible-galaxy-plus.roleSkeleton.#{skeletonChoice}"


executeAnsibleGalaxy = (args) ->
  {spawn} = require 'child_process'

  ansibleGalaxyPath = atom.config.get 'ansible-galaxy-plus.ansibleGalaxyPath'

  spawn "#{ansibleGalaxyPath}ansible-galaxy", args
