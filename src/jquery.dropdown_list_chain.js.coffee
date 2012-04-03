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
###
jQuery ($) ->
  "use_strict"

  $.fn.chainedTo = (parentElement, settings) ->
    this.each ->
      $self   = $(this)
      setup = $self.data('chain-setup')
      setup = new DropdownChain(this, parentElement) if typeof setup isnt DropdownChain
      setup.update_settings = $.extend {}, $.chain.defaults, settings
      $self.data 'chain-setup', setup.reload
  $.fn.chain = (settings) ->
    this.each ->
      $("select[data-target=##{this.id}][data-toggle=chain]").chainedTo this, settings

  $.chain =
    defaults:
      ajax: false
      include_blank: true
    version: '0.9'

  class DropdownChain
    constructor: (element, parent) ->
      @$element = $(element)
      @$clone = @$element.clone()
      @$parent = $(parent)
      @id = "#{parseInt(Math.random() * 10000)}#{new Date().getTime()}" # random integer with timestamp
      @cleanup()
    cleanup: ->
      @$element.children().remove()
    update_settings: (@settings) ->
      unbind_change_to_parent()
      bind_change_to_parent()
    bind_change_to_parent: ->
      self = this
      @$parent.bind "change.dropdown_chain.#{@id}", (e) ->
        self.reload_with $(this).val()
    unbind_change_to_parent: ->
      @$parent.unbind "change.dropdown_chain.#{@id}"
    reload_with: (val) ->
      @cleanup()
      @$element.append '<option />' if @settings.include_blank
      if @settings.ajax
      else
        @$element.append @$clone.find("option[data-chain='#{val}']").clone()