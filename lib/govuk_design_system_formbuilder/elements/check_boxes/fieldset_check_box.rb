module GOVUKDesignSystemFormBuilder
  module Elements
    module CheckBoxes
      class FieldsetCheckBox < Base
        using PrefixableArray

        include Traits::Label
        include Traits::Hint
        include Traits::Conditional

        def initialize(builder, object_name, attribute_name, value, label:, hint_text:, link_errors:, multiple:, &block)
          super(builder, object_name, attribute_name)

          @value       = value
          @label       = label
          @hint_text   = hint_text
          @multiple    = multiple
          @link_errors = link_errors

          if block_given?
            @conditional_content = wrap_conditional(block)
            @conditional_id      = conditional_id
          end
        end

        def html
          safe_join([item, @conditional_content])
        end

      private

        def item
          content_tag('div', class: %(#{brand}-checkboxes__item)) do
            safe_join([check_box, label_element, hint_element])
          end
        end

        def check_box
          @builder.check_box(@attribute_name, options, @value, false)
        end

        def options
          {
            id: field_id(link_errors: @link_errors),
            class: classes,
            multiple: @multiple,
            aria: { describedby: hint_id },
            data: { 'aria-controls' => @conditional_id }
          }
        end

        def classes
          %w(checkboxes__input).prefix(brand)
        end

        def label_element
          @label_element ||= Elements::Label.new(@builder, @object_name, @attribute_name, **label_content, **label_options)
        end

        def label_options
          { checkbox: true, value: @value, link_errors: @link_errors }
        end

        def hint_element
          @hint_element ||= Elements::Hint.new(@builder, @object_name, @attribute_name, @hint_text, @value, checkbox: true)
        end

        def conditional_classes
          %w(checkboxes__conditional checkboxes__conditional--hidden).prefix(brand)
        end
      end
    end
  end
end
