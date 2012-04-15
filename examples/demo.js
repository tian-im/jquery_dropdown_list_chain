(function() {

  jQuery(function($) {
    $('h1.title').text("" + $.chain.name + " v" + $.chain.version);
    $('title').text("Demo - " + $.chain.name);
    prettyPrint();
    $('#species').chain('#breed');
    return $('#gender').chain('#person_name', {
      ajax: {
        url: './examples/demo.json',
        dataType: 'json'
      },
      ajax_mapping: {
        filter: function(record, chainer_value) {
          if (record.chain !== chainer_value) return true;
        }
      }
    });
  });

}).call(this);
