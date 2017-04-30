path = require 'path'
fs = require 'fs-plus'
DialogView = require './dialog-view'

class CreateRoleView extends DialogView

  constructor: (initialPath) ->
    if fs.isFileSync initialPath
      directoryPath = path.dirname initialPath
    else
      directoryPath = initialPath

    {@rootProjectPath, relativeDirectoryPath} = @relativizePath directoryPath
    relativeDirectoryPath += path.sep if relativeDirectoryPath.length > 0

    super
      prompt: "Enter the path for the new Ansible Galaxy role."
      initialPath: relativeDirectoryPath
      iconClass: 'icon-file-directory-create'

  onConfirm: (rolePath) ->
    # Remove trailing whitespace
    rolePath = rolePath.replace /\s+$/, ''

    unless path.isAbsolute rolePath
      unless @rootProjectPath?
        @showError 'You must open a directory to create a file with a relative path.'
        return
      rolePath = path.join @rootProjectPath, rolePath

    return unless rolePath

    @emitter.emit 'did-confirm', rolePath: rolePath
    @cancel()

  onDidConfirm: (callback) ->
    @emitter.on 'did-confirm', callback

  relativizePath: (goalPath) ->
    pathInfo = relativeDirectoryPath: goalPath

    for projectPath in atom.project.getPaths()
      if goalPath is projectPath or goalPath.indexOf(projectPath + path.sep) is 0
        pathInfo =
          rootProjectPath: projectPath
          relativeDirectoryPath: path.relative(projectPath, goalPath)

    pathInfo

module.exports = CreateRoleView
