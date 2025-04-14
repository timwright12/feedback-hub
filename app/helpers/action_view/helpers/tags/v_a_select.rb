# frozen_string_literal: true

module ActionView
  module Helpers
    module Tags # :nodoc:
      class VASelect < Base # :nodoc:
        include SelectRenderer
        include FormOptionsHelper

        def initialize(object_name, method_name, template_object, choices, options, html_options)
          @choices = block_given? ? template_object.capture { yield || '' } : choices
          @choices = @choices.to_a if @choices.is_a?(Range)

          @html_options = html_options

          super(object_name, method_name, template_object, options)
        end

        def render
          option_tags_options = {
            selected: @options.fetch(:selected) { value.nil? ? '' : value },
            disabled: @options[:disabled]
          }

          option_tags = if grouped_choices?
                          grouped_options_for_select(@choices, option_tags_options)
                        else
                          options_for_select(@choices, option_tags_options)
                        end

          select_content_tag(option_tags, @options, @html_options)
        end

        private

        # Grouped choices look like this:
        #
        #   [nil, []]
        #   { nil => [] }
        def grouped_choices?
          !@choices.blank? && @choices.first.respond_to?(:second) && @choices.first.second.is_a?(Array)
        end

        # Disabling all because we're overwriting a rails method, so we want to keep the original in tact
        # rubocop:disable all
        def select_content_tag(option_tags, options, html_options)
          html_options = html_options.stringify_keys
          %i[required multiple size].each do |prop|
            html_options[prop.to_s] = options.delete(prop) if options.key?(prop) && !html_options.key?(prop.to_s)
          end

          add_default_name_and_id(html_options)

          if placeholder_required?(html_options)
            raise ArgumentError, 'include_blank cannot be false for a required field.' if options[:include_blank] == false

            options[:include_blank] ||= true unless options[:prompt]
          end

          html_options['data'] ||= {}
          html_options['data']['component_form_target'] = 'component'

          html_options.transform_keys!(&:dasherize)
          value = options.fetch(:selected) { value() }
          select = content_tag('va-select', add_options(option_tags, options, value), html_options)

          if html_options['multiple'] && options.fetch(:include_hidden, true)
            tag('input', disabled: html_options['disabled'], name: html_options['name'], type: 'hidden', value: '',
                         autocomplete: 'off') + select
          else
            select
          end
        end
        # rubocop:enable all
      end
    end
  end
end
