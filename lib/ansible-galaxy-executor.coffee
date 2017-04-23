path = require 'path'

module.exports =

  executeInitRole: (chosenPath) ->
    args = ['init']

    roleSkeletonPath = atom.config.get 'ansible-galaxy.roleSkeletonPath'
    if roleSkeletonPath? and roleSkeletonPath isnt ''
      args.push "--role-skeleton=#{roleSkeletonPath}"

    initPath = path.dirname chosenPath
    args.push "--init-path=#{initPath}"

    roleName = path.basename chosenPath
    args.push roleName

    cmd = executeAnsibleGalaxy args

    cmd.stdout.on 'data', (data) ->
      atom.notifications.addInfo 'Create role:', detail: data.toString() or '', dismissable: true

    cmd.stderr.on 'data', (data) ->
      console.error "stderr: #{data}"
      atom.notifications.addError 'Error:', detail: data.toString() or '', dismissable: true

    cmd.on 'close', (code) ->
      if code is 0
        atom.notifications.addSuccess 'Role created!', detail: roleName or '', dismissable: false
      else
        atom.notifications.addWarning 'Role created with errors.', detail: roleName or '', dismissable: false

executeAnsibleGalaxy = (args) ->
  {spawn} = require 'child_process'

  ansibleGalaxyPath = atom.config.get 'ansible-galaxy.ansibleGalaxyPath'

  spawn "#{ansibleGalaxyPath}ansible-galaxy", args
