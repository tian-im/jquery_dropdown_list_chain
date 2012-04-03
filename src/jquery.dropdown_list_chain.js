
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
*/

(function() {

  jQuery(function($) {
    "use_strict";
    var DropdownChain;
    $.chain = {
      defaults: {
        ajax: false,
        include_blank: {
          text: ' - '
        }
      },
      version: '0.9'
    };
    $.fn.chain = function(settings) {
      if (settings == null) settings = {};
      return this.each(function() {
        return $("select[data-target=#" + this.id + "][data-toggle=chain]").chainedTo(this, settings);
      });
    };
    $.fn.chainedTo = function(parentElement, settings) {
      if (settings == null) settings = {};
      settings = $.extend({}, $.chain.defaults, settings);
      return this.each(function() {
        var $self, setup;
        $self = $(this);
        setup = $self.data('jquery-dropdown-list-chain-setup');
        if (typeof setup !== DropdownChain) {
          setup = new DropdownChain(this, parentElement, settings);
        }
        setup.update_settings(settings);
        return $self.data('jquery-dropdown-list-chain-setup', setup);
      });
    };
    return DropdownChain = (function() {

      function DropdownChain(element, parent, settings) {
        this.settings = settings;
        this.$element = $(element);
        this.$clone = this.$element.clone();
        this.$parent = $(parent);
        this.id = "" + (parseInt(Math.random() * 10000)) + (new Date().getTime());
        this.cleanup();
      }

      DropdownChain.prototype.cleanup = function() {
        this.$element.children().remove();
        if (this.settings.include_blank) {
          return this.$element.append("<option>" + this.settings.include_blank.text + "</option>");
        }
      };

      DropdownChain.prototype.update_settings = function(settings) {
        this.settings = settings;
        return this.$parent.live("change.dropdown_chain." + this.id, {
          chain: this
        }, function(e) {
          return e.data.chain.reload_with($(this).val());
        });
      };

      DropdownChain.prototype.reload_with = function(val) {
        this.cleanup();
        if (this.settings.ajax) {} else {
          return this.$element.append(this.$clone.find("option[data-chain='" + val + "']").clone());
        }
      };

      return DropdownChain;

    })();
  });

}).call(this);
