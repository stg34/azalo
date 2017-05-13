module ActionView
  module Helpers
    class FormBuilder
      def error_messages
        object.errors.full_messages.map do |msg|
          "<p>#{msg}</p>"
        end.join.html_safe
      end

      def error_message_on(field)
        object.errors[field]
      end

    end
  end
end