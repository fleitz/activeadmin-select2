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

      if (item.attr('multiple') && !item.is('select')) {
        options.multiple = true;

        item.on('change', function(e) {
          createFakeInputs(item);
        });
      }

      options.dropdownCssClass = options.dropdownCssClass || 'bigdrop';

      // because select2 reads from input.data to check if it is select2 already
      item.data('select2', null);
      item.select2(options);
      createFakeInputs(item);
    })
  }

  var createFakeInputs = function(item) {
    var values = item.select2('val');
    var id = item.attr('id');
    var name = item.attr('name');
    $('.fake_' + id).remove();
    for (var i = 1; i < values.length; i++) {
      var value = values[i];
      var fakeId = 'fake_' + id + '_' + (i+1);
      item.append('<input type="hidden" id="' + fakeId + '" class="fake_' + id + '" name="' + name + '" value="' + value + '" />');
    }
  };

  $(document).on('has_many_add:after', '.has_many_container', function(e, fieldset) {
    initSelect2(fieldset.find('.select2-input'));
  });

  $(document).ready(function() {
    initSelect2($('.select2-input'), {placeholder: ''});
  });

});
