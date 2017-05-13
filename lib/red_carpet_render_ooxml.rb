module Redcarpet
  module Render
    class OoXml < Base

      def normal_text(text)
        text
      end

      def block_code(code, language)
        "#{normal_text(code)}"
      end

      def codespan(code)
        block_code(code, nil)
      end

      def header(title, level)
        case level
        when 1
          ooxml_h1 do
            title
          end

        when 2
          ooxml_h2 do
            title
          end

        when 3
          ooxml_h3 do
            title
          end
        end
      end

      def underline(text)
        return "#{PeriodWrapMarkerBegin}[underline]#{text}#{PeriodWrapMarkerEnd}"
      end

      def triple_emphasis(text)
        return "#{PeriodWrapMarkerBegin}[triple_emphasis]#{text}#{PeriodWrapMarkerEnd}"
      end

      def double_emphasis(text)
        return "#{PeriodWrapMarkerBegin}[double_emphasis]#{text}#{PeriodWrapMarkerEnd}"
      end

      def emphasis(text)
        return "#{PeriodWrapMarkerBegin}[emphasis]#{text}#{PeriodWrapMarkerEnd}"
      end

      def linebreak
        "\n.LP\n"
      end

      def paragraph(text)
        puts '----------------------------------------------------------------'
        puts "text = #{text}"
        puts '----------------------------------------------------------------'
        return "<w:p><w:pPr><w:pStyle w:val='style0'/></w:pPr><w:r><w:rPr/><w:t>#{text}</w:t></w:r></w:p>"
      end

      def list(content, list_type)
        case list_type
        when :ordered
          "\n\n.nr step 0 1\n#{content}\n"
        when :unordered
          "\n.\n#{content}\n"
        end
      end

      def list_item(content, list_type)
        case list_type
        when :ordered
          ".IP \\n+[step]\n#{content.strip}\n"
        when :unordered
          ".IP \\[bu] 2 \n#{content.strip}\n"
        end
      end
    end
  end
end
