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
 *  $element.chain(/* settings = {} */)
 * or
 *  $child.chainedTo($parent, /* settings = {} */)
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
    this.each ->
      $("select[data-target='##{this.id}'][data-toggle=chain]").chainedTo this, settings
      $(this).chainedTo $("##{$(this).data('target')}").get(0), settings

  $.fn.chainedTo = (parentElement, settings = {}) ->
    # only works for HTML tag SELECT
    return unless parentElement && $(parentElement).is('select') && $(this).is('select')
    settings = $.extend {}, $.chain.defaults, settings
    this.each ->
      setup = $(this).data 'jquery-dropdown-list-chain-setup'
      setup = new SelectChainSetup(this, parentElement, settings) if typeof setup isnt SelectChainSetup
      $(this).data 'jquery-dropdown-list-chain-setup', setup.reload(settings)

  class SelectChainSetup
    constructor: (element, parent, @settings) ->
      @$element = $ element
      @$clone = @$element.clone()
      @$parent = $ parent
      # random integer with timestamp
      @id = "#{parseInt(Math.random() * 10000)}#{new Date().getTime()}"
      @cleanup()
    cleanup: ->
      @$element.children().remove()
      @$element.append $("<option />").text(@settings.include_blank.text) if @settings.include_blank
    reload: (@settings) ->
      @$parent.unbind("change.dropdown_chain.#{@id}").live "change.dropdown_chain.#{@id}", { chain: this }, (e) ->
        e.data.chain.reload_with $(this).val()
      this
    reload_with: (val) ->
      @cleanup()
      if @settings.ajax
        # not support yet
      else
        @$element.append @$clone.find("option[data-chain='#{val}']").clone()