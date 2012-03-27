beforeEach ->
  this.addMatchers { # matchers go here
  toBeEmptyHash: ->
    list = (key for key, val in @actual when @actual.hasOwnProperty key)
    list.length == 0
  }
