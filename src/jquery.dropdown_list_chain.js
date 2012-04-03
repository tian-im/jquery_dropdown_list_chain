
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
    $.fn.chainedTo = function(parentElement, settings) {
      return this.each(function() {
        var $self, setup;
        $self = $(this);
        setup = $self.data('chain-setup');
        if (typeof setup !== DropdownChain) {
          setup = new DropdownChain(this, parentElement);
        }
        setup.update_settings = $.extend({}, $.chain.defaults, settings);
        return $self.data('chain-setup', setup.reload);
      });
    };
    $.fn.chain = function(settings) {
      return this.each(function() {
        return $("select[data-target=#" + this.id + "][data-toggle=chain]").chainedTo(this, settings);
      });
    };
    $.chain = {
      defaults: {
        ajax: false,
        include_blank: true
      },
      version: '0.9'
    };
    return DropdownChain = (function() {

      function DropdownChain(element, parent) {
        this.$element = $(element);
        this.$clone = this.$element.clone();
        this.$parent = $(parent);
        this.id = "" + (parseInt(Math.random() * 10000)) + (new Date().getTime());
        this.cleanup();
      }

      DropdownChain.prototype.cleanup = function() {
        return this.$element.children().remove();
      };

      DropdownChain.prototype.update_settings = function(settings) {
        this.settings = settings;
        unbind_change_to_parent();
        return bind_change_to_parent();
      };

      DropdownChain.prototype.bind_change_to_parent = function() {
        var self;
        self = this;
        return this.$parent.bind("change.dropdown_chain." + this.id, function(e) {
          return self.reload_with($(this).val());
        });
      };

      DropdownChain.prototype.unbind_change_to_parent = function() {
        return this.$parent.unbind("change.dropdown_chain." + this.id);
      };

      DropdownChain.prototype.reload_with = function(val) {
        this.cleanup();
        if (this.settings.include_blank) this.$element.append('<option />');
        if (this.settings.ajax) {} else {
          return this.$element.append(this.$clone.find("option[data-chain='" + val + "']").clone());
        }
      };

      return DropdownChain;

    })();
  });

}).call(this);
