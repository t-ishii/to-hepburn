japanese = require 'japanese'

module.exports =
class ToHepburn

  kana: /[ぁ-んァ-ンー]+/g

  convert: (@editor=atom.workspace.getActiveTextEditor()) ->
    return if not @editor?
    @replaceSelectedKana()
    return

  convertAll: (@editor=atom.workspace.getActiveTextEditor()) ->
    return if not @editor?
    @replaceAllKana(@editor.buffer)
    return

  replaceSelectedKana: () ->

    config = @getHepburnConfig()

    @editor.mutateSelectedText (selection) =>

      if not selection.isEmpty()

        text = selection.getText()
        selection.delete()
        selection.insertText(
          text.replace(
            @kana, (str) ->
              japanese.romanize(str, config)
          )
        )

  replaceAllKana: (buf) ->

    config = @getHepburnConfig()

    buf.transact =>
      buf.scan @kana, ({replace, matchText}) ->
        replace(japanese.romanize(matchText, config))

  getHepburnConfig: ->

    config = japanese.romanizationConfigs['modified hepburn']

    if atom.config.get('to-hepburn.programmingStyle')
      config['ああ'] = 'a'
      config['うう'] = 'u'
      config['ええ'] = 'e'
      config['おお'] = 'o'
      config['あー'] = 'a-'
      config['おう'] = 'o'
      config['んあ'] = 'na'

    config
