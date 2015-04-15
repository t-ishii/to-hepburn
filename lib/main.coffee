toHepburn = null
ToHepburn = null

module.exports = Main =
  config:
    'programmingStyle':
      type: 'boolean'
      default: true

  activate: ->
    @commands = atom.commands.add(
      'atom-workspace',
      'to-hepburn:convert-all': =>
        @loadModule()
        toHepburn.convertAll()
      'to-hepburn:convert': =>
        @loadModule()
        toHepburn.convert()
    )

  deactivate: ->
    @commands.dispose()

  loadModule: ->
    ToHepburn ?= require './to-hepburn'
    toHepburn ?= new ToHepburn()
