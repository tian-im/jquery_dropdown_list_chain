jQuery ($) ->
  $('h1.title').text "#{ $.chain.name } v#{ $.chain.version }"
  $('title').text "Demo - #{ $.chain.name }"
  prettyPrint()
  # demo 2
  $('#species').chain('#breed')
  $('#gender').chain '#person_name',
    ajax:
      url: './examples/demo.json'
      dataType: 'json'
    ajax_mapping:
      filter: (record, chainer_value) ->
        return true if record.chain isnt chainer_value