
/*
 * jQuery chains for dropdown list v0.9
 * @summary chains for dropdown list
 * @source_code https://github.com/chentianwen/jquery_dropdown_list_chain
 * 
 * @copyright 2011, Tianwen Chen
 * @website https://tian.im
 * 
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 *
 *
 * Usage:
 *
 * HTML Markup:
 * <select id='country' name='country'>
 *   <option />
 *   <option value='au'>Australia</option>
 *   <option value='us'>United Status</option>
 * </select>
 * <select id='state' name='state'>
 *   <option value='nsw' data-chain='au'>NSW</option>
 *   <option value='act' data-chain='au'>ACT</option>
 *   <option value='vic' data-chain='au'>VIC</option>
 *   <option value='ny' data-chain='us'>NY</option>
 *   <option value='ny' data-chain='us'>NY</option>
 *   <option value='ny' data-chain='us'>NY</option>
 * </select>
 *
 * javascript:
 *  $element.chain(settings = {})
 * or
 *  $child.chainedTo($parent, settings = {})
*/

(function() {

  jQuery(function($) {
    "use_strict";
    var SelectChain;
    $.chain = {
      defaults: {
        ajax: false,
        ajax_mapping: {
          text: 'text',
          value: 'value',
          build_option: false
        },
        include_blank: {
          text: ' - ',
          value: ''
        },
        keep_last_value: true
      },
      version: '0.9',
      name: 'jQuery Dropdown List Chain',
      attribute_name: 'jquery-dropdown-list-chain-setup',
      event_name: 'change.jquery_dropdown_list_chain'
    };
    $.fn.chain = function(chaineeElement, settings) {
      if (chaineeElement == null) chaineeElement = null;
      if (settings == null) settings = {};
      return this.each(function() {
        if (typeof chaineeElement === 'string') chaineeElement = $(chaineeElement);
        if (!SelectChain.is_select(chaineeElement)) {
          chaineeElement = $("select[data-target='#" + this.id + "'][data-toggle=chain]");
        }
        return $(chaineeElement).chainedTo(this, settings);
      });
    };
    $.fn.chainedTo = function(chainerElement, settings) {
      if (chainerElement == null) chainerElement = null;
      if (settings == null) settings = {};
      settings = $.extend({}, $.chain.defaults, settings);
      if (typeof chainerElement === 'string') {
        chainerElement = $(chainerElement)[0];
      }
      return this.each(function() {
        var setup;
        if (!SelectChain.is_select(this)) return;
        if (!SelectChain.get_element(chainerElement)) {
          chainerElement = $($(this).data('target'))[0];
        }
        if (!chainerElement) return;
        setup = $(this).data($.chain.attribute_name);
        if (!(setup instanceof SelectChain)) {
          setup = new SelectChain($(chainerElement), $(this));
        }
        return $(this).data($.chain.attribute_name, setup.update(settings));
      });
    };
    $.SelectChain = (function() {

      SelectChain.get_element = function(obj) {
        if (obj instanceof jQuery) {
          return obj[0];
        } else if (obj instanceof Element) {
          return obj;
        } else {
          return null;
        }
      };

      SelectChain.is_select = function(obj) {
        if (!(obj = SelectChain.get_element(obj))) return false;
        return /select/i.test(obj['tagName']);
      };

      function SelectChain($chainer, $chainee) {
        this.$chainer = $chainer;
        this.$chainee = $chainee;
        this.$clone = this.$chainee.clone();
        this.last_selected = {};
        this.chain_them_together();
      }

      SelectChain.prototype.chain_them_together = function() {
        if (!this.$chainer.attr('id')) {
          this.$chainer.attr('id', "chain_" + (parseInt(Math.random() * 10000)) + (new Date().getTime()));
        }
        return this.$chainee.attr('data-toggle', 'chain').attr('data-target', "#" + (this.$chainer.attr('id')));
      };

      SelectChain.prototype.update_last_selected = function() {
        if (this.settings.keep_last_value) {
          return this.last_selected[this.$chainer.val()] = this.$chainee.val();
        }
      };

      SelectChain.prototype.cleanup = function() {
        var include_blank;
        this.$chainee.children().remove();
        include_blank = this.settings.include_blank;
        if (include_blank) {
          return this.$chainee.append(this.build_option(include_blank.text, include_blank.value));
        }
      };

      SelectChain.prototype.build_option = function(text, value) {
        return $('<option />').text(text).attr('value', value);
      };

      SelectChain.prototype.update = function(settings) {
        this.settings = settings;
        this.update_last_selected();
        this.reload();
        return this;
      };

      SelectChain.prototype.reload = function() {
        this.cleanup();
        if (this.settings.ajax) {
          this.load_remote_options();
        } else {
          this.load_local_options();
        }
        if (this.settings.keep_last_value) {
          return this.$chainee.val(this.last_selected[this.$chainer.val()]);
        }
      };

      SelectChain.prototype.load_remote_options = function() {
        var mapping, self;
        self = this;
        mapping = this.settings.ajax_mapping;
        return $.ajax(this.settings.ajax).success(function(data, textStatus, jqXHR) {
          return $.each(data, function(index, record) {
            if (mapping.build_option) {
              return self.$element.append(mapping.build_option(record));
            } else {
              return self.$element.append(self.build_option(record[mapping.text], record[mapping.value]));
            }
          });
        });
      };

      SelectChain.prototype.load_local_options = function() {
        if (this.$clone) {
          return this.$chainee.append(this.$clone.find("option[data-chain='" + (this.$chainer.val()) + "']").clone());
        }
      };

      return SelectChain;

    })();
    SelectChain = $.SelectChain;
    $('select[data-toggle=chain][data-target]').chainedTo();
    return $('body').on($.chain.event_name, 'input, select, textarea', function(e) {
      var $target;
      $target = $(e.target);
      if ($target.attr('id')) {
        $("select[data-toggle=chain][data-target='#" + ($target.attr('id')) + "']").each(function() {
          return $(this).data($.chain.attribute_name).reload();
        });
      }
      if ($target.is('[data-toggle=chain][data-target]')) {
        return $target.data($.chain.attribute_name).update_last_selected();
      }
    });
  });

}).call(this);
