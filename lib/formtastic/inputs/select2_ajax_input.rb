module Formtastic
  module Inputs
    class Select2AjaxInput < Formtastic::Inputs::StringInput
      def input_html_options
        {
          name: input_name,
          type: 'hidden',
          class: 'select2-input',
          value: options[:select2][:value],
          data: {
            select2: {
              placeholder: 'Select',
              ajax: {
                url: (url = options[:select2][:url]).is_a?(Proc) ? url.call : url
              },
              init: init_value
            }
          },
          multiple: multiple
        }.merge(super)
      end

      private

      def multiple
        options[:select2][:multiple]
      end

      def input_name
        name = "#{object_name}[#{method}]"
        return name unless multiple

        "ui_#{name}[]"
      end

      def init_value
        return options[:select2][:init] if options[:select2][:init]

        object_for = ->(value) { options[:select2][:object_for].call(value) }

        value = options[:select2][:value]
        if value.is_a?(Array)
          value.map object_for
        elsif value.is_a?(String) && value.present? && value.include?(',')
          values = value.split(',')
          values.map object_for
        elsif value.present?
          object_for.call(value)
        end
      end
    end
  end
end
