module GOVUKDesignSystemFormBuilder
  module Elements
    class ErrorSummary < Base
      include Traits::Error

      def initialize(builder, object_name, title)
        @builder = builder
        @object_name = object_name
        @title = title
      end

      def html
        return nil unless object_has_errors?

        content_tag('div', class: summary_class, **summary_options) do
          safe_join([title, summary])
        end
      end

    private

      def title
        tag.h2(@title, id: summary_title_id, class: summary_class('title'))
      end

      def summary
        content_tag('div', class: summary_class('body')) do
          content_tag('ul', class: [%(#{brand}-list), summary_class('list')]) do
            safe_join(list)
          end
        end
      end

      def list
        @builder.object.errors.messages.map do |attribute, messages|
          list_item(attribute, messages.first)
        end
      end

      def list_item(attribute, message)
        tag.li(link_to(message, same_page_link(field_id(attribute)), data: { turbolinks: false }))
      end

      def same_page_link(target)
        '#'.concat(target)
      end

      def summary_class(part = nil)
        if part
          %(#{brand}-error-summary).concat('__', part)
        else
          %(#{brand}-error-summary)
        end
      end

      def field_id(attribute)
        build_id('field-error', attribute_name: attribute)
      end

      def summary_title_id
        'error-summary-title'
      end

      def object_has_errors?
        @builder.object.errors.any?
      end

      def summary_options
        {
          tabindex: -1,
          role: 'alert',
          data: {
            module: %(#{brand}-error-summary)
          },
          aria: {
            labelledby: summary_title_id
          }
        }
      end
    end
  end
end
