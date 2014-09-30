'use strict';

initSelect2 = (inputs, extra = {}) ->
  inputs.each ->
    item = $(this)
    # reading from data allows <input data-select2='{"tags": ['some']}'> to be passed to select2
    options = $.extend(allowClear: true, extra, item.data('select2'))

    if options.ajax
      options.ajax.dataType ?= 'json'
      options.ajax.data = (term, page) -> { term: term, page: page, per: 10 }
      options.ajax.results = (response, page) -> { results: response.data }
      options.minimumInputLength ?= 1
      options.initSelection = (el, callback) -> callback(options.init)

    options.dropdownCssClass ?= 'bigdrop'

    # because select2 reads from input.data to check if it is select2 already
    item.data('select2', null)
    item.select2(options)

$(document).on 'has_many_add:after', '.has_many_container', (e, fieldset) ->
  initSelect2(fieldset.find('.select2-input'))

$(document).ready ->
  initSelect2($(".select2-input"), placeholder: "")
  return
