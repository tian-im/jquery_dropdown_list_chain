jQuery ($) ->
  beforeEach ->
    @addMatchers
      toBeTypeOf: (expected) ->
        @actual instanceof expected