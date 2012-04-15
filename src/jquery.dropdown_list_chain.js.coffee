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
 * @document http://chentianwen.github.com/jquery_dropdown_list_chain/
###
jQuery ($) ->
  "use_strict"

  # options
  $.chain =
    defaults:
      include_blank:
        text: ' - '
        value: ''
      remember_last_value: true
      ajax: false # function(current_chainer_value) { return ajax_option; }
      ajax_mapping:
        text: 'text'
        value: 'value'
        build_option: false # function(record) { return $('<option />'); }
        filter: false # function(record, chainer_value) { return false; }
    version: '0.9'
    name: 'jQuery Dropdown List Chain'
    attribute_name: 'jquery-dropdown-list-chain-setup'
    event_name: 'change.jquery_dropdown_list_chain'

  $.fn.chain = (chaineeElement = null, settings = {}) ->
    this.each ->
      chaineeElement = $(chaineeElement) if typeof chaineeElement is 'string' # css selector?
      chaineeElement = $("select[data-toggle=chain][data-target='##{ this.id }']") unless SelectChain.is_select chaineeElement
      $(chaineeElement).chainedTo this, settings

  $.fn.chainedTo = (chainerElement = null, settings = {}) ->
    chainerElement = $(chainerElement)[0] if typeof chainerElement is 'string' # css selector?
    this.each ->
      return unless SelectChain.is_select this
      # default chainerElement
      chainerElement = $($(this).data 'target')[0] unless SelectChain.get_element chainerElement
      return unless chainerElement

      settings = $.extend {}, $.chain.defaults, $(this).data(), settings

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

    # public
    constructor: (@$chainer, @$chainee) ->
      @$clone         = @$chainee.clone() # keep a copy
      @last_selected  = {}
      @_chain_them_together()

    update: (@settings) ->
      @update_last_selected()
      @reload()
      @

    update_last_selected: -> # on chainee: to save current value
      @last_selected[ @$chainer.val() ] = @$chainee.val() if @settings.remember_last_value

    reload: -> # on chainer: to reload chainee options
      @_cleanup_chainee_options()
      (ajax_settings = @_load_ajax_settings()) and @_load_options_from_remote_with(ajax_settings) or @_load_options_from_local()
      @_load_last_selected()

    # private
    _chain_them_together: -> # by force
      @$chainer.attr 'id', "chain_#{ parseInt Math.random() * 10000 }#{ new Date().getTime() }" unless @$chainer.attr 'id'
      @$chainee.attr
        'data-toggle': 'chain'
        'data-target': "##{ @$chainer.attr 'id' }"

    _cleanup_chainee_options: ->
      @$chainee.children().remove()
      @$chainee.append @_build_option(include_blank.text, include_blank.value) if include_blank = @settings.include_blank

    _load_last_selected: ->
      @$chainee.val(@last_selected[ @$chainer.val() ]) if @settings.remember_last_value

    _build_option: (text, value) ->
      $('<option />').text(text).attr 'value', value

    _load_options_from_local: ->
      @$chainee.append @$clone.find("option[data-chain='#{ @$chainer.val() }']").clone() if @$clone

    # ajax
    _load_ajax_settings: ->
      ajax = ($.isFunction(ajax) and ajax() or ajax) if ajax = @settings.ajax
      unless $.isFunction(ajax.success)
        process = $.proxy @_map_each_record, @
        ajax.success = (data, textStatus, jqXHR) ->
          $.each data, process
      ajax

    _load_options_from_remote_with: (ajax_settings) ->
      $.ajax(ajax_settings)

    _map_each_record: (index, record) ->
      return if (filter = @settings.ajax_mapping.filter) and filter(record, @$chainer.val())
      return if (build_option = @settings.ajax_mapping.build_option) and build_option(record)
      (mapping = @settings.ajax_mapping) and @$chainee.append @_build_option(record[mapping.text], record[mapping.value])

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
