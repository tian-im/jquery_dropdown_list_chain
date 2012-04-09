###
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
###
jQuery ($) ->
  "use_strict"

  $.chain =
    defaults:
      ajax: false
      ajax_mapping:
        text: 'text'
        value: 'value'
        build_option: false # function(record) { option = $('<option />') }
      include_blank:
        text: ' - '
    version: '0.9'

  $.fn.chain = (childElement = null, settings = {}) ->
    this.each ->
      # only works for HTML tag SELECT
      return true unless $(this).is('select')
      # locate the children
      $("select[data-target='##{ this.id }'][data-toggle=chain]").chainedTo this, settings
      # locate the parent
      $(this).chainedTo settings

  $.fn.chainedTo = (parentElement = null, settings = {}) ->
    # only works for HTML tag SELECT
    settings = parentElement and parentElement = null unless /select/i.test(parentElement['tagName']) # parentElement is not element
    parentElement = $("##{ $(this).data 'target' }").get(0) unless parentElement
    return this unless parentElement && $(parentElement).is('select') && $(this).is('select')
    settings = $.extend {}, $.chain.defaults, settings
    this.each ->
      setup = $(this).data 'jquery-dropdown-list-chain-setup'
      setup = new SelectChain(this, parentElement) if typeof setup isnt SelectChain
      $(this).data 'jquery-dropdown-list-chain-setup', setup.update(settings)

  class SelectChain
    constructor: (element, parent) ->
      @$element   = $ element
      @$clone     = @$element.clone() # keep a copy
      @$parent    = $ parent
      # random integer with timestamp
      @id = "#{ parseInt Math.random() * 10000 }#{ new Date().getTime() }"
    cleanup: ->
      @$element.children().remove()
      @$element.append $('<option />').text(@settings.include_blank.text) if @settings.include_blank
    update: (@settings) ->
      @$parent.unbind("change.dropdown_chain.#{ @id }").live "change.dropdown_chain.#{ @id }", { chain: this }, (e) ->
        e.data.chain.reload_with $(this).val()
      this
    reload_with: (val) ->
      @cleanup()
      if @settings.ajax
        @load_remote_options()
      else
        @load_local_options()
    load_remote_options: ->
      $element = @$element
      settings = @settings
      $.ajax(settings.ajax).success (data, textStatus, jqXHR) ->
        $.each data, (index, record) ->
          if settings.ajax_mapping.build_option
            $option = settings.ajax_mapping.build_option(record)
          else
            $option = $('<option />').text(record[settings.ajax_mapping.text]).attr('value', record[settings.ajax_mapping.value])
          $element.append $option
    load_local_options: ->
      @$element.append @$clone.find("option[data-chain='#{ @parent.val() }']").clone() if @$clone