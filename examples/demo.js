(function() {

  jQuery(function($) {
    $('h1.title').text("" + $.chain.name + " v" + $.chain.version);
    $('title').text("Demo - " + $.chain.name);
    prettyPrint();
    return $('#species').chain('#breed');
  });

}).call(this);
