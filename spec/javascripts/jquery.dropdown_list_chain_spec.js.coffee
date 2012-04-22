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

      describe "._chain_them_together", ->
        it "should enforce to chain two elements together", ->
          expect(select_chain.$chainer).toBe '[id]'
          expect(select_chain.$chainee).toBe '[data-toggle=chain][data-target]'
          expect(select_chain.$chainee.data('target').substring 1).toEqual select_chain.$chainer.attr('id')

      describe "._build_option", ->
        it "should return an option element with the specified text and value", ->
          $option = select_chain._build_option 'Sydney', 'syd'
          expect($option).toBe 'option'
          expect($option).toHaveAttr 'value', 'syd'
          expect($option).toHaveText 'Sydney'

      describe "._cleanup_chainee_options", ->
        it "should clean up the options for chaineet and not append blank option as settings specify", ->
          select_chain._cleanup_chainee_options()
          expect(select_chain.$chainee).not.toContain 'option'

        it "should clean up the options for chaineet and append blank option", ->
          select_chain.settings = 
            include_blank:
              text: '- select -'
              value: '-'
          select_chain._cleanup_chainee_options()
          $option = select_chain.$chainee.children()
          expect($option.length).toBe 1
          expect($option).toBe 'option'
          expect($option).toHaveAttr 'value', '-'
          expect($option).toHaveText '- select -'

      describe ".update_last_selected ", ->
        beforeEach ->
          select_chain.$chainer.val 'InputValue'
          select_chain.$chainee.append select_chain._build_option('Value', 'Key')

        it "should remember the last value", ->
          select_chain.update_last_selected()
          expect($.isEmptyObject(select_chain.last_selected)).toBeTruthy()

        it "should clean up the options for chaineet and append blank option", ->
          select_chain.settings = 
            remember_last_value: true
          select_chain.update_last_selected()
          expect(select_chain.last_selected['InputValue']).toEqual 'Key'

      describe ".update_last_selected ", ->
        it "should remember the last value", ->

        it "should clean up the options for chaineet and append blank option", ->

      ###
      it "should NOT be blank", ->
        expect($.InFieldLabel.is_blank "not empty string").toBeFalsy()
        expect($.InFieldLabel.is_blank $(document.body)).toBeFalsy()
        
    describe "#find_data_options_for", ->
      it "should return blank options", ->
        $input = $ '<input />'
        expect($.InFieldLabel.find_data_options_for $input).toBeEmptyHash()
        
      it "should return options for in-field label only", ->
        $input = $ '<input data-align="right"/>'
        expect(($.InFieldLabel.find_data_options_for $input).align).toEqual('right')
        
    describe "#append_input_after_label", ->
      it "should move and append the input after the label", ->
        setFixtures '<label for="address_field">Address: <input id="address_field" type="text" /></label>'
        $label = $ 'label', $('#jasmine-fixtures')
        $input = $ 'input', $('#jasmine-fixtures')
        expect($label).toBe('[for]:has(input)')
        $.InFieldLabel.append_input_after_label $input, $label
        expect($label).not.toBe('[for]:has(input)')
        expect($label.next()).toBe("input[id=#{$label.attr 'for'}]")

      it "should move and append the input after the label, add attribute 'id' to input and 'for' to label in order to link them up", ->
        setFixtures '<label>Email: <input type="text" /></label>'
        $label = $ 'label', $('#jasmine-fixtures')
        $input = $ 'input', $('#jasmine-fixtures')
        expect($label).toBe(':not([for]):has(input)')
        $.InFieldLabel.append_input_after_label $input, $label
        expect($label).not.toBe(':has(input)')
        expect($input).toBe('[id]')
        expect($label.next()).toBe("input[id=#{$label.attr 'for'}]")

    describe "#reposition_label_to_front_of_input", ->
      it "should reposition the lable to the front and by default align to the left of the input", ->
        $label = $ '<label for="address_field">Address:</label>'
        $input = $ '<input id="address_field" type="text" />'
        $.InFieldLabel.reposition_label_to_front_of_input $label, $input, {align: 'right'}
        expect($label.css 'position').toEqual('absolute')
        expect($label.css 'cursor').toEqual('text')

    describe ".setup", ->
      it "should setup for input which is outside of associated label", ->
        setFixtures '<label for="address_field">Address:</label><input id="address_field" type="text" value="sydney" />'
        $label = $ 'label', $('#jasmine-fixtures')
        $input = $ 'input', $('#jasmine-fixtures')
        $input.in_field_label()
        expect($input.data 'in_field_label_status').toEqual('all_set')
        expect($input).toHandle('keyup')
        expect($input).toHandle('focus')
        expect($input).toHandle('blur')
        expect($input).toHaveClass('in_field_label_class')
        expect($label).toHaveClass('in_field_label_class')
        expect($label.css 'opacity').toEqual('0')

      it "should setup for input which is inside of a label", ->
        setFixtures '<label>Address: <input type="text" value="sydney" /></label>'
        $label = $ 'label', $('#jasmine-fixtures')
        $input = $ 'input', $('#jasmine-fixtures')
        $input.in_field_label()
        expect($input.data 'in_field_label_status').toEqual('all_set')
        expect($input).toBe('[id]')
        expect($label.next()).toBe("input[id=#{$label.attr 'for'}]")
        expect($input).toHandle('keyup')
        expect($input).toHandle('focus')
        expect($input).toHandle('blur')
        expect($input).toHaveClass('in_field_label_class')
        expect($label).toHaveClass('in_field_label_class')
        expect($label.css 'opacity').toEqual('0')

      it "should not setup for input which has no associated label", ->
        setFixtures '<input id="address_field" type="text" value="sydney" />'
        $input = $ 'input', $('#jasmine-fixtures')
        $input.in_field_label()
        expect($input.data 'in_field_label_status').not.toEqual('all_set')
        expect($input).not.toHaveClass('in_field_label_class')
    ###