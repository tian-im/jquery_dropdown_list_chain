
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
 * @document http://chentianwen.github.com/jquery_dropdown_list_chain/
*/

(function() {

  jQuery(function($) {
    "use_strict";
    var SelectChain;
    $.chain = {
      defaults: {
        include_blank: {
          text: ' - ',
          value: ''
        },
        remember_last_value: true,
        ajax: false,
        ajax_mapping: {
          text: 'text',
          value: 'value',
          build_option: false,
          filter: false
        }
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
          chaineeElement = $("select[data-toggle=chain][data-target='#" + this.id + "']");
        }
        return $(chaineeElement).chainedTo(this, settings);
      });
    };
    $.fn.chainedTo = function(chainerElement, settings) {
      if (chainerElement == null) chainerElement = null;
      if (settings == null) settings = {};
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
        settings = $.extend({}, $.chain.defaults, $(this).data(), settings);
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
        this._chain_them_together();
      }

      SelectChain.prototype.update = function(settings) {
        this.settings = settings;
        this.update_last_selected();
        this.reload();
        return this;
      };

      SelectChain.prototype.update_last_selected = function() {
        if (this.settings.remember_last_value) {
          return this.last_selected[this.$chainer.val()] = this.$chainee.val();
        }
      };

      SelectChain.prototype.reload = function() {
        var ajax_settings;
        this._cleanup_chainee_options();
        (ajax_settings = this._load_ajax_settings()) && this._load_options_from_remote_with(ajax_settings) || this._load_options_from_local();
        return this._load_last_selected();
      };

      SelectChain.prototype._chain_them_together = function() {
        if (!this.$chainer.attr('id')) {
          this.$chainer.attr('id', "chain_" + (parseInt(Math.random() * 10000)) + (new Date().getTime()));
        }
        return this.$chainee.attr({
          'data-toggle': 'chain',
          'data-target': "#" + (this.$chainer.attr('id'))
        });
      };

      SelectChain.prototype._cleanup_chainee_options = function() {
        var include_blank;
        this.$chainee.children().remove();
        if (include_blank = this.settings.include_blank) {
          return this.$chainee.append(this._build_option(include_blank.text, include_blank.value));
        }
      };

      SelectChain.prototype._load_last_selected = function() {
        if (this.settings.remember_last_value) {
          return this.$chainee.val(this.last_selected[this.$chainer.val()]);
        }
      };

      SelectChain.prototype._build_option = function(text, value) {
        return $('<option />').text(text).attr('value', value);
      };

      SelectChain.prototype._load_options_from_local = function() {
        if (this.$clone) {
          return this.$chainee.append(this.$clone.find("option[data-chain='" + (this.$chainer.val()) + "']").clone());
        }
      };

      SelectChain.prototype._load_ajax_settings = function() {
        var ajax;
        if (ajax = this.settings.ajax) return $.isFunction(ajax) && ajax() || ajax;
      };

      SelectChain.prototype._load_options_from_remote_with = function(ajax_settings) {
        var process;
        process = $.proxy(this._map_each_record, this);
        return $.ajax(ajax_settings).done(function(data, textStatus, jqXHR) {
          return $.each(data, process);
        });
      };

      SelectChain.prototype._map_each_record = function(index, record) {
        var build_option, filter, mapping;
        if ((filter = this.settings.ajax_mapping.filter) && filter(record, this.$chainer.val())) {
          return;
        }
        if ((build_option = this.settings.ajax_mapping.build_option) && build_option(record)) {
          return;
        }
        return (mapping = this.settings.ajax_mapping) && this.$chainee.append(this._build_option(record[mapping.text], record[mapping.value]));
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
