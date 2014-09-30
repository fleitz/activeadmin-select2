module Formtastic
  module Inputs

    class Select2AjaxInput < Formtastic::Inputs::StringInput
      def input_html_options
        {
          :type => 'hidden',
          :class => 'select2-input',
          :value => options[:select2][:value],
          :data => {
            :select2 => {
              :placeholder => 'Select',
              :ajax => {
                :url => options[:select2][:url]
              },
              :init => init_value
            }
          },
          :multiple => options[:select2][:multiple]
        }.merge(super)
      end


      private

      def init_value
        return options[:select2][:init] if options[:select2][:init]

        object_for = ->(value) { options[:select2][:object_for].call(value) }

        value = options[:select2][:value]
        if Array === value
          value.map object_for
        elsif String === value && value.present? && value.include?(',')
          values = value.split(',')
          values.map object_for
        elsif value.present?
          object_for.call(value)
        end
      end
    end
  end
end
