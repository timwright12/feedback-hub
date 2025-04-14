# frozen_string_literal: true

module ActionView
  module Helpers
    module Tags
      class VATextField < Base
        def render
          options = @options.stringify_keys
          options['size'] = options['maxlength'] unless options.key?('size')
          options['use-forms-pattern'] = true
          options['type'] ||= field_type
          options['value'] = options.fetch('value') { value_before_type_cast } unless field_type == 'file'
          options.transform_keys!(&:dasherize)
          add_default_name_and_id(options)
          tag('va-text-input', options)
        end

        class << self
          def field_type
            @field_type ||= name.split('::').last.sub('Field', '').downcase
          end
        end

        private

        def field_type
          self.class.field_type
        end
      end
    end
  end
end
