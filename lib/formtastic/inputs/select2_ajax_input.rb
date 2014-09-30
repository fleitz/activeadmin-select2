module Formtastic
  module Inputs

    class Select2AjaxInput < Formtastic::Inputs::StringInput
      def input_html_options
        {
          :type => 'hidden',
          :class => 'select2-input'
        }.merge(super)
      end
    end
  end
end
