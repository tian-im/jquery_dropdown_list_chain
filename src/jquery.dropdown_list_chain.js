
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
 * usage:
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
          text: ' - '
        }
      },
      version: '0.9'
    };
    $.fn.chain = function(childElement, settings) {
      if (childElement == null) childElement = null;
      if (settings == null) settings = {};
      return this.each(function() {
        if (!$(this).is('select')) return true;
        $("select[data-target='#" + this.id + "'][data-toggle=chain]").chainedTo(this, settings);
        return $(this).chainedTo(settings);
      });
    };
    $.fn.chainedTo = function(parentElement, settings) {
      if (parentElement == null) parentElement = null;
      if (settings == null) settings = {};
      if (!/select/i.test(parentElement['tagName'])) {
        settings = parentElement && (parentElement = null);
      }
      if (!parentElement) parentElement = $("#" + ($(this).data('target'))).get(0);
      if (!(parentElement && $(parentElement).is('select') && $(this).is('select'))) {
        return this;
      }
      settings = $.extend({}, $.chain.defaults, settings);
      return this.each(function() {
        var setup;
        setup = $(this).data('jquery-dropdown-list-chain-setup');
        if (typeof setup !== SelectChain) {
          setup = new SelectChain(this, parentElement);
        }
        return $(this).data('jquery-dropdown-list-chain-setup', setup.update(settings));
      });
    };
    return SelectChain = (function() {

      function SelectChain(element, parent) {
        this.$element = $(element);
        this.$clone = this.$element.clone();
        this.$parent = $(parent);
        this.id = "" + (parseInt(Math.random() * 10000)) + (new Date().getTime());
      }

      SelectChain.prototype.cleanup = function() {
        this.$element.children().remove();
        if (this.settings.include_blank) {
          return this.$element.append($('<option />').text(this.settings.include_blank.text));
        }
      };

      SelectChain.prototype.update = function(settings) {
        this.settings = settings;
        this.$parent.unbind("change.dropdown_chain." + this.id).live("change.dropdown_chain." + this.id, {
          chain: this
        }, function(e) {
          return e.data.chain.reload_with($(this).val());
        });
        return this;
      };

      SelectChain.prototype.reload_with = function(val) {
        this.cleanup();
        if (this.settings.ajax) {
          return this.load_remote_options();
        } else {
          return this.load_local_options();
        }
      };

      SelectChain.prototype.load_remote_options = function() {
        var $element, settings;
        $element = this.$element;
        settings = this.settings;
        return $.ajax(settings.ajax).success(function(data, textStatus, jqXHR) {
          return $.each(data, function(index, record) {
            var $option;
            if (settings.ajax_mapping.build_option) {
              $option = settings.ajax_mapping.build_option(record);
            } else {
              $option = $('<option />').text(record[settings.ajax_mapping.text]).attr('value', record[settings.ajax_mapping.value]);
            }
            return $element.append($option);
          });
        });
      };

      SelectChain.prototype.load_local_options = function() {
        if (this.$clone) {
          return this.$element.append(this.$clone.find("option[data-chain='" + (this.parent.val()) + "']").clone());
        }
      };

      return SelectChain;

    })();
  });

}).call(this);
