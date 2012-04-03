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
 *  $parent.chain(/* settings = {} */)
 *  $child.chain(/* settings = {} */)
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
    return unless parentElement
    settings = $.extend {}, $.chain.defaults, settings
    this.each ->
      $self   = $ this
      setup = $self.data 'jquery-dropdown-list-chain-setup'
      setup = new DropdownChain(this, parentElement, settings) if typeof setup isnt DropdownChain
      setup.update_settings(settings)
      $self.data 'jquery-dropdown-list-chain-setup', setup

  class DropdownChain
    constructor: (element, parent, @settings) ->
      @$element = $ element
      @$clone = @$element.clone()
      @$parent = $ parent
      @id = "#{parseInt(Math.random() * 10000)}#{new Date().getTime()}" # random integer with timestamp
      @cleanup()
    cleanup: ->
      @$element.children().remove()
      @$element.append "<option>#{@settings.include_blank.text}</option>" if @settings.include_blank
    update_settings: (@settings) ->
      @$parent.live "change.dropdown_chain.#{@id}", { chain: this }, (e) ->
        e.data.chain.reload_with $(this).val()
    reload_with: (val) ->
      @cleanup()
      if @settings.ajax
        # not support yet
      else
        @$element.append @$clone.find("option[data-chain='#{val}']").clone()