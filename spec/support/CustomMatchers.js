(function() {

  beforeEach(function() {
    return this.addMatchers({
      toBeEmptyHash: function() {
        var key, list, val;
        list = (function() {
          var _len, _ref, _results;
          _ref = this.actual;
          _results = [];
          for (val = 0, _len = _ref.length; val < _len; val++) {
            key = _ref[val];
            if (this.actual.hasOwnProperty(key)) _results.push(key);
          }
          return _results;
        }).call(this);
        return list.length === 0;
      }
    });
  });

}).call(this);
