japanese = require 'japanese'

module.exports =
class ToHepburn

  convert: (@editor=atom.workspace.getActiveTextEditor()) ->
    return if not @editor?

    @editor.mutateSelectedText (selection) =>
      if not selection.isEmpty()

        text = selection.getText()
        selection.delete()
        selection.insertText(japanese.romanize(
          text,
          @getHepburnConfig()
        ))

    return

  convertAll: (@editor=atom.workspace.getActiveTextEditor()) ->
    return if not @editor?

  getHepburnConfig: ->

    config = japanese.romanizationConfigs['modified hepburn']

    if atom.config.get('to-hepburn.programming')
      config['ああ'] = 'a'
      config['うう'] = 'u'
      config['ええ'] = 'e'
      config['おお'] = 'o'
      config['あー'] = 'a-'
      config['おう'] = 'o'
      config['んあ'] = 'na'

    config
