jQuery ($) ->
  describe "SelectChain", ->
		describe "#is_select", ->
      it "should say yes if element is select", ->
        expect($.SelectChain.is_select $('<select />').get(0)).toBeTruthy()
        expect($.SelectChain.is_select $('<select />')).toBeTruthy()


      it "should say no unless element is select", ->
        expect($.SelectChain.is_select $('<input />').get(0)).toBeFalsy()
        expect($.SelectChain.is_select {}).toBeFalsy()

    describe ".build_option", ->
      it "should"
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