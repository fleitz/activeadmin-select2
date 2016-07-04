'use strict';

# select2 stores the value as `value="one,two,three"` on the text input
# since we need to send an array to the server, create hidden fields for the values
createSelectedOptionTags = (item)  ->
  values = item.val()
  id = item.attr('id')
  item.empty()

  for value, i in values
    optionId = 'option_' + id + '_' + (i+1)
    item.append('<option id="' + optionId + '" class="option_' + id + '" value="' + value + '" selected="selected" >'+value+'</option>')


initSelect2 = (inputs, extra = {}) ->
  inputs.each ->

    item = $(this)
    if item.attr('activeadmin-select2') == 'true'
      debugger;
      return
    item.attr('activeadmin-select2','true')
    # reading from data allows <input data-select2='{"tags": ['some']}'> to be passed to select2
    options = $.extend(allowClear: true, extra, item.data('select2'))

    # ajax
    if options.ajax
      options.ajax.dataType = options.ajax.dataType || 'json'
      options.minimumInputLength = options.minimumInputLength || 1
      options.ajax.data = (params) ->
        return { term: params.term, page: params.page, per: 10 }
      options.ajax.processResults = (response) ->
        return { results: response.data }

    # multiple
    multiple = item.attr('multiple') && !item.is('select');
    if multiple
      options.multiple = true

    # dropdow css class
    options.dropdownCssClass = options.dropdownCssClass || 'bigdrop'

    # because select2 reads from input.data to check if it is select2 already
    item.data('select2',null)
    item.select2(options)
    debugger;

    

    # multiple || tags
    if multiple || options.tags
      createSelectedOptionTags(item)
      item.on 'change', (e) ->
        createSelectedOptionTags(item)

$(document).on 'has_many_add:after', '.has_many_container', (e, fieldset) ->
  initSelect2(fieldset.find('.select2-input'))

$(document).on 'ready page:load turbolinks:load', ->
  initSelect2($(".select2-input"), placeholder: "")
  return
