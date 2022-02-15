# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class DatePickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    merged_input_options[:class] << 'form-control'

    merged_input_options[:type] = :date
    template.content_tag(:div, class: 'input-group') do
      input = @builder.text_field(attribute_name, merged_input_options)
      span = template.content_tag(:span, class: 'input-group-addon') do
        template.content_tag(:span, '', class: 'glyphicon glyphicon-calendar')
      end
      "#{input} #{span}".html_safe
    end
  end
end
