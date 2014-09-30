module ActiveAdmin
  module Inputs
    class FilterSelect2AjaxInput < Formtastic::Inputs::StringInput

      include FilterBase

      def to_html
        input_wrapping do
          label_html <<
          builder.text_field(input_name, input_html_options)
        end
      end

      # If MetaSearch already responds to the given method, just use it.
      #
      # Otherwise:
      # When it's a HABTM or has_many association, Formtastic builds "object_ids".
      # That doesn't fit our scenario, so we override it here.
      def input_name
        # "#{super}_in"

        return method if @object.respond_to? method

        name = attribute_name
        name.concat multiple? ? '_in' : '_eq'
      end

      def attribute_name
        name = method.to_s
        name.concat '_id' if reflection
        name
      end

      def input_html_options
        {
          :type => 'hidden',
          :class => 'select2-input',
          :data => {
            :select2 => {
              :placeholder => I18n.t('active_admin.any'),
              :allowClear => true,
              :ajax => {
                :url => options[:select2][:url]
              },
              :init => value ? options[:select2][:object_for].call(value) : nil
            }
          }
        }.merge(super)
      end

      def value
        if @object.respond_to?(:search_attributes)
          # AA 0.x uses meta_search
          @object.search_attributes[attribute_name + (multiple? ? '_contains' : '_equals')]
        else
          # AA 1+ uses Ransack
          condition = @object.base.conditions.find {|c| c.attributes.first.name == attribute_name}
          condition.values.first.value if condition
        end
      end

      # Provide the AA translation to the blank input field.
      def include_blank
        I18n.t 'active_admin.any' if super
      end

      # was "#{object_name}[#{association_primary_key}]"
      # def input_html_options_name
      #   "#{object_name}[#{input_name}]"
      # end

      def multiple_by_options?
        options[:multiple] || (options[:input_html] && options[:input_html][:multiple])
      end

      # Don't make it multiple for HABTM or has_many unless explicitely stated
      def multiple?
        multiple_by_options?
      end

      def single?
        !multiple?
      end

      # Provides an efficient default lookup query if the attribute is a DB column.
      def collection
        unless Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR < 2
          return pluck_column if !options[:collection] && column_for(method)
        end
        super
      end

      def pluck_column
        @object.base.reorder("#{method} asc").uniq.pluck method
      end

    end
  end
end
