'use strict';

# select2 stores the value as `value="one,two,three"` on the text input
# since we need to send an array to the server, create hidden fields for the values
createHiddenInputs = (item)  ->
  values = item.select2('val')
  id = item.attr('id')
  name = item.attr('name').replace(/^ui_/, '')
  $('.hidden_' + id).remove()

  if values.length == 0
    item.append('<input type="hidden" class="hidden_' + id + '" name="' + name + '" />')
  else
    for value, i in values
      hiddenId = 'hidden_' + id + '_' + (i+1)
      item.append('<input type="hidden" id="' + hiddenId + '" class="hidden_' + id + '" name="' + name + '" value="' + value + '" />')


initSelect2 = (inputs, extra = {}) ->
  inputs.each ->
    item = $(this)
    # reading from data allows <input data-select2='{"tags": ['some']}'> to be passed to select2
    options = $.extend(allowClear: true, extra, item.data('select2'))

    # ajax
    if options.ajax
      options.ajax.dataType = options.ajax.dataType || 'json'
      options.minimumInputLength = options.minimumInputLength || 1
      options.ajax.data = (term, page) ->
        return { term: term, page: page, per: 10 }
      options.ajax.results = (response, page) ->
        return { results: response.data }
      options.initSelection = (el, callback) ->
        callback(options.init)

    # multiple
    multiple = item.attr('multiple') && !item.is('select');
    if multiple
      options.multiple = true

    # dropdow css class
    options.dropdownCssClass = options.dropdownCssClass || 'bigdrop'

    # because select2 reads from input.data to check if it is select2 already
    item.data('select2', null)
    item.select2(options)

    # multiple || tags
    if multiple || options.tags
      createHiddenInputs(item)
      item.on 'change', (e) ->
        createHiddenInputs(item)

$(document).on 'has_many_add:after', '.has_many_container', (e, fieldset) ->
  initSelect2(fieldset.find('.select2-input'))

$(document).on 'ready page:load turbolinks:load', ->
  initSelect2($(".select2-input"), placeholder: "")
  return
