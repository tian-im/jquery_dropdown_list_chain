(function() {

  jQuery(function($) {
    $('h1.title').text("jQuery Dropdown List Chain v" + $.chain.version);
    return $('#country').chain({
      ajax: {
        url: './Demo.json.html',
        dataType: 'json'
      }
    });
  });

}).call(this);
