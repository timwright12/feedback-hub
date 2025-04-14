# frozen_string_literal: true

class VADesignSystemBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::FormTagHelper

  def va_text_field(method, options = {})
    ActionView::Helpers::Tags::VATextField.new(@object_name, method, @template, options).render
  end

  def va_select(method, choices = nil, options = {}, html_options = {}, &block)
    ActionView::Helpers::Tags::VASelect.new(@object_name, method, @template, choices, options, html_options, &block).render
  end

  def va_date(method, options = {})
    ActionView::Helpers::Tags::VADateField.new(@object_name, method, @template, options).render
  end

  def va_submit(value = nil, options = {})
    options = options.deep_stringify_keys
    tag_options = { 'name' => 'commit', 'value' => value, 'text' => value, 'submit' => true }.update(options)
    set_default_disable_with value, tag_options
    tag 'va-button', tag_options
  end
end
