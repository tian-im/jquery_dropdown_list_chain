(function() {

  jQuery(function($) {
    return describe("InFieldLabel", function() {
      describe("#is_blank", function() {
        it("should be blank", function() {
          expect($.InFieldLabel.is_blank(void 0)).toBeTruthy();
          expect($.InFieldLabel.is_blank(null)).toBeTruthy();
          expect($.InFieldLabel.is_blank(NaN)).toBeTruthy();
          expect($.InFieldLabel.is_blank("")).toBeTruthy();
          expect($.InFieldLabel.is_blank(" ")).toBeTruthy();
          return expect($.InFieldLabel.is_blank($('unknow'))).toBeTruthy();
        });
        return it("should NOT be blank", function() {
          expect($.InFieldLabel.is_blank("not empty string")).toBeFalsy();
          return expect($.InFieldLabel.is_blank($(document.body))).toBeFalsy();
        });
      });
      describe("#find_data_options_for", function() {
        it("should return blank options", function() {
          var $input;
          $input = $('<input />');
          return expect($.InFieldLabel.find_data_options_for($input)).toBeEmptyHash();
        });
        return it("should return options for in-field label only", function() {
          var $input;
          $input = $('<input data-align="right"/>');
          return expect(($.InFieldLabel.find_data_options_for($input)).align).toEqual('right');
        });
      });
      describe("#append_input_after_label", function() {
        it("should move and append the input after the label", function() {
          var $input, $label;
          setFixtures('<label for="address_field">Address: <input id="address_field" type="text" /></label>');
          $label = $('label', $('#jasmine-fixtures'));
          $input = $('input', $('#jasmine-fixtures'));
          expect($label).toBe('[for]:has(input)');
          $.InFieldLabel.append_input_after_label($input, $label);
          expect($label).not.toBe('[for]:has(input)');
          return expect($label.next()).toBe("input[id=" + ($label.attr('for')) + "]");
        });
        return it("should move and append the input after the label, add attribute 'id' to input and 'for' to label in order to link them up", function() {
          var $input, $label;
          setFixtures('<label>Email: <input type="text" /></label>');
          $label = $('label', $('#jasmine-fixtures'));
          $input = $('input', $('#jasmine-fixtures'));
          expect($label).toBe(':not([for]):has(input)');
          $.InFieldLabel.append_input_after_label($input, $label);
          expect($label).not.toBe(':has(input)');
          expect($input).toBe('[id]');
          return expect($label.next()).toBe("input[id=" + ($label.attr('for')) + "]");
        });
      });
      describe("#reposition_label_to_front_of_input", function() {
        return it("should reposition the lable to the front and by default align to the left of the input", function() {
          var $input, $label;
          $label = $('<label for="address_field">Address:</label>');
          $input = $('<input id="address_field" type="text" />');
          $.InFieldLabel.reposition_label_to_front_of_input($label, $input, {
            align: 'right'
          });
          expect($label.css('position')).toEqual('absolute');
          return expect($label.css('cursor')).toEqual('text');
        });
      });
      return describe(".setup", function() {
        it("should setup for input which is outside of associated label", function() {
          var $input, $label;
          setFixtures('<label for="address_field">Address:</label><input id="address_field" type="text" value="sydney" />');
          $label = $('label', $('#jasmine-fixtures'));
          $input = $('input', $('#jasmine-fixtures'));
          $input.in_field_label();
          expect($input.data('in_field_label_status')).toEqual('all_set');
          expect($input).toHandle('keyup');
          expect($input).toHandle('focus');
          expect($input).toHandle('blur');
          expect($input).toHaveClass('in_field_label_class');
          expect($label).toHaveClass('in_field_label_class');
          return expect($label.css('opacity')).toEqual('0');
        });
        it("should setup for input which is inside of a label", function() {
          var $input, $label;
          setFixtures('<label>Address: <input type="text" value="sydney" /></label>');
          $label = $('label', $('#jasmine-fixtures'));
          $input = $('input', $('#jasmine-fixtures'));
          $input.in_field_label();
          expect($input.data('in_field_label_status')).toEqual('all_set');
          expect($input).toBe('[id]');
          expect($label.next()).toBe("input[id=" + ($label.attr('for')) + "]");
          expect($input).toHandle('keyup');
          expect($input).toHandle('focus');
          expect($input).toHandle('blur');
          expect($input).toHaveClass('in_field_label_class');
          expect($label).toHaveClass('in_field_label_class');
          return expect($label.css('opacity')).toEqual('0');
        });
        return it("should not setup for input which has no associated label", function() {
          var $input;
          setFixtures('<input id="address_field" type="text" value="sydney" />');
          $input = $('input', $('#jasmine-fixtures'));
          $input.in_field_label();
          expect($input.data('in_field_label_status')).not.toEqual('all_set');
          return expect($input).not.toHaveClass('in_field_label_class');
        });
      });
    });
  });

}).call(this);
