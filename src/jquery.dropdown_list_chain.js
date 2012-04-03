
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
    var SelectChainSetup;
    $.chain = {
      defaults: {
        ajax: false,
        include_blank: {
          text: ' - '
        }
      },
      ajax_defaults: {
        mapping: function(data, $select) {
          return $.each(data, function(index, record) {
            return $select.append($('<option />').text(record.text).attr('value', record.value));
          });
        }
      },
      version: '0.9'
    };
    $.fn.chain = function(settings) {
      if (settings == null) settings = {};
      if (!$(this).is('select')) return this;
      return this.each(function() {
        $("select[data-target='#" + this.id + "'][data-toggle=chain]").chainedTo(this, settings);
        return $(this).chainedTo(null, settings);
      });
    };
    $.fn.chainedTo = function(parentElement, settings) {
      if (parentElement == null) parentElement = null;
      if (settings == null) settings = {};
      if (!parentElement) parentElement = $("#" + ($(this).data('target'))).get(0);
      if (!(parentElement && $(parentElement).is('select') && $(this).is('select'))) {
        return this;
      }
      settings = $.extend({}, $.chain.defaults, settings);
      return this.each(function() {
        var setup;
        setup = $(this).data('jquery-dropdown-list-chain-setup');
        if (typeof setup !== SelectChainSetup) {
          setup = new SelectChainSetup(this, parentElement, settings);
        }
        return $(this).data('jquery-dropdown-list-chain-setup', setup.update(settings));
      });
    };
    return SelectChainSetup = (function() {

      function SelectChainSetup(element, parent, settings) {
        this.settings = settings;
        this.$element = $(element);
        if (!this.settings.ajax) this.$clone = this.$element.clone();
        this.$parent = $(parent);
        this.id = "" + (parseInt(Math.random() * 10000)) + (new Date().getTime());
        this.cleanup();
      }

      SelectChainSetup.prototype.cleanup = function() {
        this.$element.children().remove();
        if (this.settings.include_blank) {
          return this.$element.append($('<option />').text(this.settings.include_blank.text));
        }
      };

      SelectChainSetup.prototype.update = function(settings) {
        this.settings = settings;
        this.$parent.unbind("change.dropdown_chain." + this.id).live("change.dropdown_chain." + this.id, {
          chain: this
        }, function(e) {
          return e.data.chain.reload_with($(this).val());
        });
        return this;
      };

      SelectChainSetup.prototype.reload_with = function(val) {
        this.cleanup();
        if (this.settings.ajax) {
          return this.load_remote_options();
        } else {
          return this.load_local_options();
        }
      };

      SelectChainSetup.prototype.load_remote_options = function() {
        var $element, ajax_settings;
        $element = this.$element;
        ajax_settings = $.extend({}, $.chain.ajax_defaults, this.settings.ajax);
        return $.ajax(ajax_settings).success(function(data, textStatus, jqXHR) {
          return ajax_settings.mapping(data, $element);
        });
      };

      SelectChainSetup.prototype.load_local_options = function() {
        if (this.$clone) {
          return this.$element.append(this.$clone.find("option[data-chain='" + (this.parent.val()) + "']").clone());
        }
      };

      return SelectChainSetup;

    })();
  });

}).call(this);
