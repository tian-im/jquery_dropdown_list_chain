jQuery ($) ->
  $('h1.title').text "#{ $.chain.name } v#{ $.chain.version }"
  $('title').text "Demo - #{ $.chain.name }"
  prettyPrint()