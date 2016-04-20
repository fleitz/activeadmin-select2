require 'formtastic/inputs/select2_ajax_input'

module ActiveAdmin
  module Inputs
    class FilterSelect2AjaxInput < Formtastic::Inputs::SelectInput

      include ActiveAdmin::Inputs::Filters::Base

      def input_name
        return method if seems_searchable?

        searchable_method_name.concat multiple? ? '_in' : '_eq'
      end

      def searchable_method_name
        if searchable_has_many_through?
          "#{reflection.through_reflection.name}_#{reflection.foreign_key}"
        else
          name = method.to_s
          name.concat '_id' if reflection
          name
        end
      end

      # Provide the AA translation to the blank input field.
      def include_blank
        I18n.t 'active_admin.any' if super
      end

      def input_html_options_name
        "#{object_name}[#{input_name}]" # was "#{object_name}[#{association_primary_key}]"
      end

      # Would normally return true for has_many and HABTM, which would subsequently
      # cause the select field to be multi-select instead of a dropdown.
      def multiple_by_association?
        false
      end

      # Provides an efficient default lookup query if the attribute is a DB column.
      def collection
        if !options[:collection] && column
          pluck_column
        else
          super
        end
      end

      def pluck_column
        distinct = ActiveAdmin::Dependency.rails >= 4 ? :distinct : :uniq
        klass.reorder("#{method} asc").public_send(distinct).pluck method
      end

      def input_html_options
        {
          name: input_name,
          class: 'select2-input',
          data: {
            select2: {
              placeholder: I18n.t('active_admin.any'),
              ajax: {
                url: (url = options[:select2][:url]).is_a?(Proc) ? url.call : url
              }
            }
          }
        }.merge(super)
      end

      # # was "#{object_name}[#{association_primary_key}]"
      def input_html_options_name
        "#{object_name}[#{input_name}]"
      end

      def multiple_by_options?
        options[:multiple] || (options[:input_html] && options[:input_html][:multiple])
      end

      # # Don't make it multiple for HABTM or has_many unless explicitely stated
      def multiple?
        multiple_by_options?
      end
    end
  end
end
