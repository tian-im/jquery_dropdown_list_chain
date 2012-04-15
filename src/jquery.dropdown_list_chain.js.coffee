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
 * Usage:
 *
 * HTML Markup:
 * <select id='country' name='country'>
 *   <option />
 *   <option value='au'>Australia</option>
 *   <option value='us'>United Status</option>
 * </select>
 * <select id='state' name='state'>
 *   <option value='nsw' data-chain='au'>NSW</option>
 *   <option value='act' data-chain='au'>ACT</option>
 *   <option value='vic' data-chain='au'>VIC</option>
 *   <option value='ny' data-chain='us'>NY</option>
 *   <option value='ny' data-chain='us'>NY</option>
 *   <option value='ny' data-chain='us'>NY</option>
 * </select>
 *
 * javascript:
 *  $element.chain(settings = {})
 * or
 *  $child.chainedTo($parent, settings = {})
###
jQuery ($) ->
  "use_strict"

  # options
  $.chain =
    defaults:
      ajax: false
      ajax_mapping:
        text: 'text'
        value: 'value'
        build_option: false # function(record) { return $('<option />').text(record.text).attr('value', record.value) }
      include_blank:
        text: ' - '
        value: ''
      keep_last_value: true
    version: '0.9'
    name: 'jQuery Dropdown List Chain'
    attribute_name: 'jquery-dropdown-list-chain-setup'
    event_name: 'change.jquery_dropdown_list_chain'

  $.fn.chain = (chaineeElement = null, settings = {}) ->
    this.each ->
      chaineeElement = $(chaineeElement) if typeof chaineeElement is 'string' # css selector?
      chaineeElement = $("select[data-target='##{ this.id }'][data-toggle=chain]") unless SelectChain.is_select chaineeElement
      $(chaineeElement).chainedTo this, settings

  $.fn.chainedTo = (chainerElement = null, settings = {}) ->
    settings = $.extend {}, $.chain.defaults, settings
    chainerElement = $(chainerElement)[0] if typeof chainerElement is 'string' # css selector?
    this.each ->
      return unless SelectChain.is_select this
      # default chainerElement
      chainerElement = $($(this).data 'target')[0] unless SelectChain.get_element chainerElement
      return unless chainerElement

      # update setup
      setup = $(this).data $.chain.attribute_name
      setup = new SelectChain($(chainerElement), $(this)) unless setup instanceof SelectChain
      $(this).data $.chain.attribute_name, setup.update(settings) # update setup

  class $.SelectChain
    @get_element: (obj) ->
      if obj instanceof jQuery
        obj[0]
      else if obj instanceof Element
        obj
      else
        null

    @is_select: (obj) ->
      return false unless obj = SelectChain.get_element(obj)
      /select/i.test obj['tagName']

    constructor: (@$chainer, @$chainee) ->
      @$clone         = @$chainee.clone() # keep a copy
      @last_selected  = {}
      @chain_them_together()

    chain_them_together: -> # force to establish the connection between them
      @$chainer.attr 'id', "chain_#{ parseInt Math.random() * 10000 }#{ new Date().getTime() }" unless @$chainer.attr 'id'
      @$chainee.attr('data-toggle', 'chain').attr 'data-target', "##{ @$chainer.attr 'id' }"

    update_last_selected: -> # on chainee: to save current value
      @last_selected[ @$chainer.val() ] = @$chainee.val() if @settings.keep_last_value

    cleanup: ->
      @$chainee.children().remove()
      include_blank = @settings.include_blank
      @$chainee.append @build_option(include_blank.text, include_blank.value) if include_blank

    build_option: (text, value) ->
      $('<option />').text(text).attr 'value', value

    update: (@settings) ->
      @update_last_selected(); @reload(); @

    reload: -> # on chainer: to reload chainee options
      @cleanup()
      if @settings.ajax
        @load_remote_options()
      else
        @load_local_options()
      @$chainee.val(@last_selected[ @$chainer.val() ]) if @settings.keep_last_value

    load_remote_options: ->
      self    = @
      mapping = @settings.ajax_mapping
      $.ajax(@settings.ajax).success (data, textStatus, jqXHR) ->
        $.each data, (index, record) ->
          if mapping.build_option
            self.$element.append mapping.build_option(record)
          else
            self.$element.append self.build_option(record[mapping.text], record[mapping.value])

    load_local_options: ->
      @$chainee.append @$clone.find("option[data-chain='#{ @$chainer.val() }']").clone() if @$clone

  SelectChain = $.SelectChain

  # trigger default
  $('select[data-toggle=chain][data-target]').chainedTo();

  # only setup the event once.
  $('body').on $.chain.event_name, 'input, select, textarea', (e) ->
    $target = $(e.target)
    if $target.attr 'id' # chainer?
      $("select[data-toggle=chain][data-target='##{ $target.attr 'id' }']").each ->
        $(this).data($.chain.attribute_name).reload()
    if $target.is '[data-toggle=chain][data-target]' # chainee?
      $target.data($.chain.attribute_name).update_last_selected()
