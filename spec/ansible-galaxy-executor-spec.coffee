ansibleGalaxyExecutor = require '../lib/ansible-galaxy-executor'

describe 'ansible galaxy executor', ->

  it 'should return empty rolename when path is empty.', ->
    chosenPath = ''

    meta = ansibleGalaxyExecutor.makeGalaxyInitRoleMeta chosenPath

    expect(meta).toEqualJson roleName: '', cmdArgs: [
      'init',
      '--init-path=.',
      ''
    ]

  it 'should return init path with "." when path is relative.', ->
    chosenPath = 'foobar'

    meta = ansibleGalaxyExecutor.makeGalaxyInitRoleMeta chosenPath

    expect(meta).toEqualJson roleName: 'foobar', cmdArgs: [
      'init',
      '--init-path=.',
      'foobar'
    ]

  it 'should split root path and role name when path is absolute.', ->
    chosenPath = '/foo/bar/foobar'

    meta = ansibleGalaxyExecutor.makeGalaxyInitRoleMeta chosenPath

    expect(meta).toEqualJson roleName: 'foobar', cmdArgs: [
      'init',
      '--init-path=/foo/bar',
      'foobar'
    ]

  it 'should add "role-skeleton" argument when skeleton is defined.', ->
    atom.config.set 'ansible-galaxy.roleSkeletonPath', '/my/role/skeleton'
    chosenPath = '/foo/bar/foobar'

    meta = ansibleGalaxyExecutor.makeGalaxyInitRoleMeta chosenPath

    expect(meta).toEqualJson roleName: 'foobar', cmdArgs: [
      'init',
      '--role-skeleton=/my/role/skeleton'
      '--init-path=/foo/bar',
      'foobar'
    ]
