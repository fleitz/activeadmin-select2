module Formtastic
  module Inputs
    class Select2AjaxInput < Formtastic::Inputs::SelectInput
      def input_html_options
        {
          name: input_name,
          class: 'select2-input',
          data: {
            select2: {
              placeholder: 'Select',
              ajax: {
                url: (url = options[:select2][:url]).is_a?(Proc) ? url.call : url
              },
            }
          },
          multiple: multiple
        }.merge(super)
      end

      private

      def multiple
        options[:select2][:multiple]
      end

      # def input_name
      #   method
      # end

    end
  end
end
