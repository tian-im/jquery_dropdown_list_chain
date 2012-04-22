jQuery ($) ->
  describe "SelectChain", ->
    describe "class methods", ->
      describe "#get_element", ->
        it "should return only element", ->
          expect($.SelectChain.get_element $('<select />')).toBeTypeOf Element
          expect($.SelectChain.get_element document.createElement('select')).toBeTypeOf Element

        it "should return null", ->
          expect($.SelectChain.get_element 'string').toBeNull()
          expect($.SelectChain.get_element 1).toBeNull()

      describe "#is_select", ->
        it "should say yes if element is select", ->
          expect($.SelectChain.is_select $('<select />').get(0)).toBeTruthy()
          expect($.SelectChain.is_select $('<select />')).toBeTruthy()

        it "should say no unless element is select", ->
          expect($.SelectChain.is_select $('<input />').get(0)).toBeFalsy()
          expect($.SelectChain.is_select $('<input />')).toBeFalsy()
          expect($.SelectChain.is_select {}).toBeFalsy()
          expect($.SelectChain.is_select undefined).toBeFalsy()

    describe "instance methods", ->
      beforeEach ->
        window.select_chain = new $.SelectChain($('<input />'), $('<select></select>'))
        select_chain.settings = {}

      describe ".constructor", ->
        it "should have chainer and chainee set", ->
          expect(select_chain.$chainer).not.toBeNull()
          expect(select_chain.$chainee).not.toBeNull()
          expect(select_chain.$chainee).not.toEqual select_chain.$clone

      describe ".update_last_selected", ->
        beforeEach ->
          select_chain.$chainer.val 'InputValue'
          select_chain.$chainee.append select_chain._build_option('Text', 'Key')

        it "should remember the last value", ->
          expect(select_chain.update_last_selected()).toBeUndefined()
          expect($.isEmptyObject(select_chain.last_selected)).toBeTruthy()

        it "should clean up the options for chaineet and append blank option", ->
          select_chain.settings = 
            remember_last_value: true
          expect(select_chain.update_last_selected()).not.toBeUndefined()
          expect(select_chain.last_selected['InputValue']).toEqual 'Key'

      describe ".update", ->

      describe ".reload", ->

      describe "._chain_them_together", ->
        it "should enforce to chain two elements together", ->
          expect(select_chain.$chainer).toBe '[id]'
          expect(select_chain.$chainee).toBe '[data-toggle=chain][data-target]'
          expect(select_chain.$chainee.data('target').substring 1).toEqual select_chain.$chainer.attr('id')

      describe "._cleanup_chainee_options", ->
        it "should clean up the options for chaineet and not append blank option as settings specify", ->
          expect(select_chain._cleanup_chainee_options()).toBeUndefined()
          expect(select_chain.$chainee).not.toContain 'option'

        it "should clean up the options for chaineet and append blank option", ->
          select_chain.settings = 
            include_blank:
              text: '- select -'
              value: '-'
          expect(select_chain._cleanup_chainee_options()).not.toBeUndefined()
          $option = select_chain.$chainee.children()
          expect($option.length).toBe 1
          expect($option).toBe 'option'
          expect($option).toHaveAttr 'value', '-'
          expect($option).toHaveText '- select -'

      describe "._load_last_selected ", ->
        beforeEach ->
          select_chain.$chainer.val 'InputValue'
          select_chain.$chainee.append select_chain._build_option('-', '-')
          select_chain.$chainee.append select_chain._build_option('Text', 'Key')
          select_chain.last_selected['InputValue'] = 'Key'

        it "should not load the last selected value for the dropdown list", ->
          expect(select_chain._load_last_selected()).toBeUndefined()
          expect(select_chain.$chainee.val()).toEqual '-'

        it "should load the last selected value for the dropdown list", ->
          select_chain.settings =
            remember_last_value: true
          expect(select_chain._load_last_selected()).not.toBeUndefined()
          expect(select_chain.$chainee.val()).toEqual 'Key'

      describe "._build_option", ->
        it "should return an option element with the specified text and value", ->
          $option = select_chain._build_option 'Sydney', 'syd'
          expect($option).toBe 'option'
          expect($option).toHaveAttr 'value', 'syd'
          expect($option).toHaveText 'Sydney'

      describe "._load_options_from_local", ->
        beforeEach ->
          select_chain.$chainer.val 'InputValue'
          select_chain.$chainee.append select_chain._build_option('Text1', 'Key1').attr('data-chain', 'OtherValue')
          select_chain.$chainee.append select_chain._build_option('Text2', 'Key2').attr('data-chain', 'InputValue')
          select_chain.$chainee.append select_chain._build_option('Text3', 'Key3').attr('data-chain', 'InputValue')
          select_chain.last_selected['InputValue'] = 'Key3'
          select_chain.$clone = select_chain.$chainee.clone()
          select_chain._cleanup_chainee_options()

        it "should load the options locally from the clone chainee object", ->
          select_chain._load_options_from_local()
          expect(select_chain.$chainee.children().length).toEqual 2
          expect(select_chain.$chainee.val()).toEqual 'Key2'

        it "should load the options locally from the clone chainee object", ->
          select_chain.settings =
            remember_last_value: true
          select_chain._load_options_from_local()
          expect(select_chain.$chainee.children().length).toEqual 2
          expect(select_chain.$chainee.val()).toEqual 'Key3'

