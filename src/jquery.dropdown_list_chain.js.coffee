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
      include_blank:
        text: ' - '
    version: '0.9'

  $.fn.chain = (settings = {}) ->
    # only works for HTML tag SELECT
    return this unless $(this).is('select')
    this.each ->
      # locate the children
      $("select[data-target='##{ this.id }'][data-toggle=chain]").chainedTo this, settings
      # locate the parent
      $(this).chainedTo null, settings

  $.fn.chainedTo = (parentElement = null, settings = {}) ->
    # only works for HTML tag SELECT
    parentElement = $("##{ $(this).data 'target' }").get(0) unless parentElement
    return this unless parentElement && $(parentElement).is('select') && $(this).is('select')
    settings = $.extend {}, $.chain.defaults, settings
    this.each ->
      setup = $(this).data 'jquery-dropdown-list-chain-setup'
      setup = new SelectChainSetup(this, parentElement, settings) if typeof setup isnt SelectChainSetup
      $(this).data 'jquery-dropdown-list-chain-setup', setup.update(settings)

  class SelectChainSetup
    constructor: (element, parent, @settings) ->
      @$element = $ element
      @$clone = @$element.clone() unless @settings.ajax
      @$parent = $ parent
      # random integer with timestamp
      @id = "#{ parseInt Math.random() * 10000 }#{ new Date().getTime() }"
      @cleanup()
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
      # TODO: not support yet
      [ $element, settings ] = [ @$element, @settings ]
      $.ajax(@settings.ajax).success (data, textStatus, jqXHR) ->
        $.each data, (index, record) ->
          eval("var text = record.#{ settings.ajax.text }")
          eval("var value = record.#{ settings.ajax.value }")
          $element.append $('<option />').text(text).attr('value', value)
    load_local_options: ->
      @$element.append @$clone.find("option[data-chain='#{val}']").clone() if @$clone