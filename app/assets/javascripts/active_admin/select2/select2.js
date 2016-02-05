$(function() {

  'use strict';

  var initSelect2 = function(inputs, extra) {
    if (!extra) { extra = {}; }

    inputs.each(function() {
      var item = $(this);

      // reading from data allows <input data-select2='{"tags": ['some']}'> to be passed to select2
      var options = $.extend({allowClear: true}, extra, item.data('select2'));

      if (options.ajax) {
        options.ajax.dataType = options.ajax.dataType || 'json';
        options.minimumInputLength = options.minimumInputLength || 1;
        options.ajax.data = function(term, page) {
          return { term: term, page: page, per: 10 };
        };
        options.ajax.results = function(response, page) {
          return { results: response.data };
        };
        options.initSelection = function(el, callback) {
          callback(options.init);
        };
      }

      var multiple = item.attr('multiple') && !item.is('select');
      if (multiple) {
        options.multiple = true;
      }

      options.dropdownCssClass = options.dropdownCssClass || 'bigdrop';

      // because select2 reads from input.data to check if it is select2 already
      item.data('select2', null);

      item.select2(options);

      if (multiple || options.tags) {
        createHiddenInputs(item);
        item.on('change', function(e) {
          createHiddenInputs(item);
        });
      }
    })
  }

  // select2 stores the value as `value="one,two,three"` on the text input
  // since we need to send an array to the server, create hidden fields for the values
  var createHiddenInputs = function(item) {
    var values = item.select2('val');
    var id = item.attr('id');
    var name = item.attr('name').replace(/^ui_/, '');
    $('.hidden_' + id).remove();

    if (values.length === 0) {
      item.append('<input type="hidden" class="hidden_' + id + '" name="' + name + '" />');
    } else {
      for (var i = 0; i < values.length; i++) {
        var value = values[i];
        var hiddenId = 'hidden_' + id + '_' + (i+1);
        item.append('<input type="hidden" id="' + hiddenId + '" class="hidden_' + id + '" name="' + name + '" value="' + value + '" />');
      }
    }
  };

  $(document).on('has_many_add:after', '.has_many_container', function(e, fieldset) {
    initSelect2(fieldset.find('.select2-input'));
  });

  $(document).ready(function() {
    initSelect2($('.select2-input'), {placeholder: ''});
  });

});
