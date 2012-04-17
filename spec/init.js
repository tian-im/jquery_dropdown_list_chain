(function() {

  jQuery(function($) {
    var currentWindowOnload, execJasmine, jasmineEnv, trivialReporter;
    jasmineEnv = jasmine.getEnv();
    jasmineEnv.updateInterval = 1000;
    trivialReporter = new jasmine.TrivialReporter();
    jasmineEnv.addReporter(trivialReporter);
    jasmineEnv.specFilter = function(spec) {
      return trivialReporter.specFilter(spec);
    };
    currentWindowOnload = window.onload;
    window.onload = function() {
      if (currentWindowOnload) currentWindowOnload();
      return execJasmine();
    };
    return execJasmine = function() {
      return jasmineEnv.execute();
    };
  });

}).call(this);
