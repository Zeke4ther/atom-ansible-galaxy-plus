ansibleGalaxyExecutor = require '../lib/ansible-galaxy-executor'

describe 'ansible galaxy executor', ->

  it 'should return empty rolename when path is empty.', ->
    chosenPath = ''

    meta = ansibleGalaxyExecutor.makeGalaxyInitRoleMeta chosenPath

    expect(meta).toEqualJson
      roleName: ''
      cmdArgs: [
        'init',
        '--init-path=.',
        ''
      ]
      skeletonType: undefined
      skeletonPath: undefined

  it 'should return init path with "." when path is relative.', ->
    chosenPath = 'foobar'

    meta = ansibleGalaxyExecutor.makeGalaxyInitRoleMeta chosenPath

    expect(meta).toEqualJson
      roleName: 'foobar'
      cmdArgs: [
        'init',
        '--init-path=.',
        'foobar'
      ]
      skeletonType: undefined
      skeletonPath: undefined

  it 'should split root path and role name when path is absolute.', ->
    chosenPath = '/foo/bar/foobar'

    meta = ansibleGalaxyExecutor.makeGalaxyInitRoleMeta chosenPath

    expect(meta).toEqualJson
      roleName: 'foobar'
      cmdArgs: [
        'init',
        '--init-path=/foo/bar',
        'foobar'
      ]
      skeletonType: undefined
      skeletonPath: undefined

  it 'should not add "role-skeleton" argument when roleSkeleton.choice is set to none.', ->
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.choice', 'none'
    chosenPath = '/foo/bar/foobar'

    meta = ansibleGalaxyExecutor.makeGalaxyInitRoleMeta chosenPath

    expect(meta).toEqualJson
      roleName: 'foobar'
      cmdArgs: [
        'init',
        '--init-path=/foo/bar',
        'foobar'
      ]
      skeletonType: 'none'
      skeletonPath: ''

  it 'should add "role-skeleton" argument with path A when roleSkeleton.choice is set to skeleton-a.', ->
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.skeleton-a', '/my/role/skeleton/a'
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.skeleton-b', '/my/role/skeleton/b'
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.skeleton-c', '/my/role/skeleton/c'
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.choice', 'skeleton-a'

    chosenPath = '/foo/bar/foobar'

    meta = ansibleGalaxyExecutor.makeGalaxyInitRoleMeta chosenPath

    expect(meta).toEqualJson
      roleName: 'foobar'
      cmdArgs: [
        'init',
        '--role-skeleton=/my/role/skeleton/a'
        '--init-path=/foo/bar',
        'foobar'
      ]
      skeletonType: 'skeleton-a'
      skeletonPath: '/my/role/skeleton/a'

  it 'should add "role-skeleton" argument with path B when roleSkeleton.choice is set to skeleton-b.', ->
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.skeleton-a', '/my/role/skeleton/a'
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.skeleton-b', '/my/role/skeleton/b'
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.skeleton-c', '/my/role/skeleton/c'
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.choice', 'skeleton-b'

    chosenPath = '/foo/bar/foobar'

    meta = ansibleGalaxyExecutor.makeGalaxyInitRoleMeta chosenPath

    expect(meta).toEqualJson
      roleName: 'foobar'
      cmdArgs: [
        'init',
        '--role-skeleton=/my/role/skeleton/b'
        '--init-path=/foo/bar',
        'foobar'
      ]
      skeletonType: 'skeleton-b'
      skeletonPath: '/my/role/skeleton/b'

  it 'should add "role-skeleton" argument with path C when roleSkeleton.choice is set to skeleton-c.', ->
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.skeleton-a', '/my/role/skeleton/a'
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.skeleton-b', '/my/role/skeleton/b'
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.skeleton-c', '/my/role/skeleton/c'
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.choice', 'skeleton-c'

    chosenPath = '/foo/bar/foobar'

    meta = ansibleGalaxyExecutor.makeGalaxyInitRoleMeta chosenPath

    expect(meta).toEqualJson
      roleName: 'foobar'
      cmdArgs: [
        'init',
        '--role-skeleton=/my/role/skeleton/c'
        '--init-path=/foo/bar',
        'foobar'
      ]
      skeletonType: 'skeleton-c'
      skeletonPath: '/my/role/skeleton/c'

  it 'should not add "role-skeleton" argument when roleSkeleton.PathX is not defined.', ->
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.skeleton-a', '/my/role/skeleton/a'
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.skeleton-b', '/my/role/skeleton/b'
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.skeleton-c', ''
    atom.config.set 'ansible-galaxy-plus.roleSkeleton.choice', 'skeleton-c'
    chosenPath = '/foo/bar/foobar'

    meta = ansibleGalaxyExecutor.makeGalaxyInitRoleMeta chosenPath

    expect(meta).toEqualJson
      roleName: 'foobar'
      cmdArgs: [
        'init',
        '--init-path=/foo/bar',
        'foobar'
      ]
      skeletonType: 'skeleton-c'
      skeletonPath: ''
