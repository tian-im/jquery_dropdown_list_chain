(function() {

  jQuery(function($) {
    return describe("SelectChain", function() {
      describe("class methods", function() {
        describe("#get_element", function() {
          it("should return only element", function() {
            expect($.SelectChain.get_element($('<select />'))).toBeTypeOf(Element);
            return expect($.SelectChain.get_element(document.createElement('select'))).toBeTypeOf(Element);
          });
          return it("should return null", function() {
            expect($.SelectChain.get_element('string')).toBeNull();
            return expect($.SelectChain.get_element(1)).toBeNull();
          });
        });
        return describe("#is_select", function() {
          it("should say yes if element is select", function() {
            expect($.SelectChain.is_select($('<select />').get(0))).toBeTruthy();
            return expect($.SelectChain.is_select($('<select />'))).toBeTruthy();
          });
          return it("should say no unless element is select", function() {
            expect($.SelectChain.is_select($('<input />').get(0))).toBeFalsy();
            expect($.SelectChain.is_select($('<input />'))).toBeFalsy();
            expect($.SelectChain.is_select({})).toBeFalsy();
            return expect($.SelectChain.is_select(void 0)).toBeFalsy();
          });
        });
      });
      return describe("instance methods", function() {
        beforeEach(function() {
          window.select_chain = new $.SelectChain($('<input />'), $('<select></select>'));
          return select_chain.settings = {};
        });
        describe(".constructor", function() {
          return it("should have chainer and chainee set", function() {
            expect(select_chain.$chainer).not.toBeNull();
            expect(select_chain.$chainee).not.toBeNull();
            return expect(select_chain.$chainee).not.toEqual(select_chain.$clone);
          });
        });
        describe(".update_last_selected", function() {
          beforeEach(function() {
            select_chain.$chainer.val('InputValue');
            return select_chain.$chainee.append(select_chain._build_option('Text', 'Key'));
          });
          it("should remember the last value", function() {
            expect(select_chain.update_last_selected()).toBeUndefined();
            return expect($.isEmptyObject(select_chain.last_selected)).toBeTruthy();
          });
          return it("should clean up the options for chaineet and append blank option", function() {
            select_chain.settings = {
              remember_last_value: true
            };
            expect(select_chain.update_last_selected()).not.toBeUndefined();
            return expect(select_chain.last_selected['InputValue']).toEqual('Key');
          });
        });
        describe(".update", function() {});
        describe(".reload", function() {});
        describe("._chain_them_together", function() {
          return it("should enforce to chain two elements together", function() {
            expect(select_chain.$chainer).toBe('[id]');
            expect(select_chain.$chainee).toBe('[data-toggle=chain][data-target]');
            return expect(select_chain.$chainee.data('target').substring(1)).toEqual(select_chain.$chainer.attr('id'));
          });
        });
        describe("._cleanup_chainee_options", function() {
          it("should clean up the options for chaineet and not append blank option as settings specify", function() {
            expect(select_chain._cleanup_chainee_options()).toBeUndefined();
            return expect(select_chain.$chainee).not.toContain('option');
          });
          return it("should clean up the options for chaineet and append blank option", function() {
            var $option;
            select_chain.settings = {
              include_blank: {
                text: '- select -',
                value: '-'
              }
            };
            expect(select_chain._cleanup_chainee_options()).not.toBeUndefined();
            $option = select_chain.$chainee.children();
            expect($option.length).toBe(1);
            expect($option).toBe('option');
            expect($option).toHaveAttr('value', '-');
            return expect($option).toHaveText('- select -');
          });
        });
        describe("._load_last_selected ", function() {
          beforeEach(function() {
            select_chain.$chainer.val('InputValue');
            select_chain.$chainee.append(select_chain._build_option('-', '-'));
            select_chain.$chainee.append(select_chain._build_option('Text', 'Key'));
            return select_chain.last_selected['InputValue'] = 'Key';
          });
          it("should not load the last selected value for the dropdown list", function() {
            expect(select_chain._load_last_selected()).toBeUndefined();
            return expect(select_chain.$chainee.val()).toEqual('-');
          });
          return it("should load the last selected value for the dropdown list", function() {
            select_chain.settings = {
              remember_last_value: true
            };
            expect(select_chain._load_last_selected()).not.toBeUndefined();
            return expect(select_chain.$chainee.val()).toEqual('Key');
          });
        });
        describe("._build_option", function() {
          return it("should return an option element with the specified text and value", function() {
            var $option;
            $option = select_chain._build_option('Sydney', 'syd');
            expect($option).toBe('option');
            expect($option).toHaveAttr('value', 'syd');
            return expect($option).toHaveText('Sydney');
          });
        });
        return describe("._load_options_from_local", function() {
          beforeEach(function() {
            select_chain.$chainer.val('InputValue');
            select_chain.$chainee.append(select_chain._build_option('Text1', 'Key1').attr('data-chain', 'OtherValue'));
            select_chain.$chainee.append(select_chain._build_option('Text2', 'Key2').attr('data-chain', 'InputValue'));
            select_chain.$chainee.append(select_chain._build_option('Text3', 'Key3').attr('data-chain', 'InputValue'));
            select_chain.last_selected['InputValue'] = 'Key3';
            select_chain.$clone = select_chain.$chainee.clone();
            return select_chain._cleanup_chainee_options();
          });
          it("should load the options locally from the clone chainee object", function() {
            select_chain._load_options_from_local();
            expect(select_chain.$chainee.children().length).toEqual(2);
            return expect(select_chain.$chainee.val()).toEqual('Key2');
          });
          return it("should load the options locally from the clone chainee object", function() {
            select_chain.settings = {
              remember_last_value: true
            };
            select_chain._load_options_from_local();
            expect(select_chain.$chainee.children().length).toEqual(2);
            return expect(select_chain.$chainee.val()).toEqual('Key3');
          });
        });
      });
    });
  });

}).call(this);
