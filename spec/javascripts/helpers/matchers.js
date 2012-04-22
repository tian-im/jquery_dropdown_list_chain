(function() {

  jQuery(function($) {
    return beforeEach(function() {
      return this.addMatchers({
        toBeTypeOf: function(expected) {
          return this.actual instanceof expected;
        }
      });
    });
  });

}).call(this);
