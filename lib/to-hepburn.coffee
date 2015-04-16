japanese = require 'japanese'

module.exports =
class ToHepburn

  # 置換対象文字列
  kana: /[ぁ-んァ-ンー]+/g

  # 選択対象のヘボン式化
  convert: (@editor=atom.workspace.getActiveTextEditor()) ->
    # 対象エディタが見つからない場合は終了
    return if not @editor?
    # 選択されたカナ文字をヘボン式に変換
    @replaceSelectedKana()
    return

  # すべてをヘボン式化
  convertAll: (@editor=atom.workspace.getActiveTextEditor()) ->
    # 対象エディタが見つからない場合は終了
    return if not @editor?
    # すべてのカナ文字をヘボン式へ変換
    @replaceAllKana(@editor.buffer)
    return

  replaceSelectedKana: ->

    # ヘボン式用の設定を読み込み
    config = @getHepburnConfig()

    # 選択されているテキストの編集を行う
    @editor.mutateSelectedText (selection) =>

      if not selection.isEmpty()

        # 選択部分のテキストを取得
        text = selection.getText()

        # 対象テキストの削除
        selection.delete()

        # ヘボン式にしたテキストを挿入
        selection.insertText(
          text.replace(
            @kana, (str) ->
              japanese.romanize(str, config)
          )
        )

    return

  replaceAllKana: (buf) ->

    # ヘボン式用の設定を読み込み
    config = @getHepburnConfig()

    # トランザクション処理開始
    buf.transact =>
      # 置換対象文字を置き換えていく
      buf.scan @kana, ({replace, matchText}) ->
        replace(japanese.romanize(matchText, config))

  getHepburnConfig: ->

    # ヘボン式の設定を取得
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
