describe 'Ansible Galaxy Plus', ->
  pack = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'ansible-galaxy-plus'
        .then (p) -> pack = p

  it 'should load the package', ->
    expect(pack.name).toBe 'ansible-galaxy-plus'
