require 'formtastic/inputs/string_input'

module Formtastic
  module Inputs

    class Select2TagsInput < Formtastic::Inputs::StringInput
      def input_html_options
        {
          name: "ui_#{object_name}[#{method}][]",
          class: 'select2-input select2-tags-input',
          data: {
            select2: {
              tags: options[:collection] || [],
              tokenSeparators: [",", " "]
            }
          },
          value: value
        }.merge(super)
      end

      private

      def value
        val = object.send(method)
        if Array === val
          val = val.join(',')
        end
        val
      end
    end

  end
end
