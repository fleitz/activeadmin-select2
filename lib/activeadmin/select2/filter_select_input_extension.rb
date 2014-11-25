module ActiveAdmin
  module Select2
    module Inputs
      module FilterSelectInputExtension

        def extra_input_html_options
          {
            class: 'select2-input',
            data: {
              select2: {
                placeholder: I18n.t('active_admin.any')
              }
            }
          }
        end

        def input_options
          super.merge({
            prompt: '',
            include_blank: false
          })
        end

      end
    end
  end
end
