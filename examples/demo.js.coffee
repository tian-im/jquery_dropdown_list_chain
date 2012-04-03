jQuery ($) ->
  $('h1.title').text "jQuery Dropdown List Chain v#{$.chain.version}"
  $('#country').chain({ ajax: { url: './Demo.json.html' , dataType: 'json' } })