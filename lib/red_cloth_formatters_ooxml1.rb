# encoding: UTF-8
require 'cgi'

module RedCloth
  module Formatters
    module Ooxml

      PeriodWrapMarkerBegin = 'B-B-B-B'
      PeriodWrapMarkerEnd = 'E-E-E-E'

      class Sanitizer
        def self.strip_tags(text)
          # use Rails Sanitizer if available
          begin
            text = ActionController::Base.helpers.strip_tags(text)
          rescue
            # otherwise, use custom method inspired from:
            # RedCloth::Formatters::HTML.clean_html
            # not very secure, but it's ok as output is still
            # meant to be escaped if it needs to be shown
            text.gsub!( /<!\[CDATA\[/, '' )
            text.gsub!( /<(\/*)([A-Za-z]\w*)([^>]*?)(\s?\/?)>/ ){|m| block_given? ? yield(m) : ""}
          end
          CGI.unescapeHTML(text)
        end
      end

      include RedCloth::Formatters::Base
      include OoxmlBuilderHelper

      def split_text_to_periods(text)
        marker_positions_begin = []
        marker_positions_end = []

        i = -1
        n = 0
        while i = text.index(PeriodWrapMarkerBegin, i + 1)
          marker_positions_begin[n] = i
          n += 1
        end

        i = -1
        n = 0
        while i = text.index(PeriodWrapMarkerEnd, i + 1)
          marker_positions_end[n] = i + PeriodWrapMarkerEnd.size
          n += 1
        end

        marker_positions = marker_positions_begin.zip(marker_positions_end)

        period_textes = []

        marker_positions.flatten!
        marker_positions << text.size
        marker_positions.insert(0, 0)
        marker_positions.uniq!

        marker_positions.each_with_index do |pos, i|

          next if i == 0

          period = text[marker_positions[i-1]...marker_positions[i]]

          if period.start_with?(PeriodWrapMarkerBegin) && period.end_with?(PeriodWrapMarkerEnd)
            idx1 = period.index('[')
            idx2 = period.index(']')
            period_styles = period[idx1+1...idx2]
            period = period[idx2+1...period.size - PeriodWrapMarkerEnd.size]
            period_textes << [period, period_styles.split(',').map{|s| s.to_sym}]
          else
            period_textes << [period, []]
          end
        end
        return period_textes
      end

      def oo_xml_helpers
        unless @helper_proxy
          @helper_proxy = ActionView::Base.new
          @helper_proxy.extend OoxmlBuilderHelper
        else
          @helper_proxy
        end
      end

      def h1(opts)
        oo_xml_helpers.ooxml_h1 do
          opts[:text]
        end
      end

      def h2(opts)
        oo_xml_helpers.ooxml_h2 do
          opts[:text]
        end
      end

      def h3(opts)
        oo_xml_helpers.ooxml_h3 do
          opts[:text]
        end
      end

      def h4(opts)
        oo_xml_helpers.ooxml_h4 do
          opts[:text]
        end
      end

      def h5(opts)
        oo_xml_helpers.ooxml_h5 do
          opts[:text]
        end
      end

      def h6(opts)
        oo_xml_helpers.ooxml_h6 do
          opts[:text]
        end
      end

      [:p, :div, :pre].each do |m|
        define_method(m) do |opts|
          text = opts[:text]
          #puts "paragraph text: #{text}"
          period_textes = split_text_to_periods(text)
          #pp period_textes
          #puts "BLOCK=#{opts[:block]}"
          #puts "BC=#{opts[:bc]}"
          if opts[:bq]
            func = :ooxml_block_quote
          else
            func = :ooxml_paragraph
          end
          ret = ''
          ret << send(func) do
            text = ''
            period_textes.each do |period_text|
              text << ooxml_period(period_text[1]) do
                "#{period_text[0]}"
              end
            end
            text
          end
          #puts ret
          return ret
        end
      end


      #[:h1, :h2, :h3, :h4, :h5, :h6, :p, :pre, :div].each do |m|
      #  define_method(m) do |opts|
      #    ooxml_h1(@oo_builder) do
      #      "#{opts[:text]}\n\n"
      #    end
      #  end
      #end

      [:strong, :em, :ins, :sup, :sub, :del, :cite, :code].each do |m|
        define_method(m) do |opts|
          opts[:block] = true
          text = opts[:text]
          if text.start_with?(PeriodWrapMarkerBegin)
            ret = text.insert(text.index('[') + 1, "#{m},")
          else
            ret = "#{PeriodWrapMarkerBegin}[#{m}]#{text}#{PeriodWrapMarkerEnd}"
          end
          return ret
        end
      end

      [:span, :i, :b].each do |m|
        define_method(m) do |opts|
          opts[:block] = true
          text = opts[:text]
          return "#{text}"
        end
      end

      def hr(opts)
        return '<w:p><w:pPr><w:pStyle w:val="style25"/></w:pPr><w:r><w:rPr/></w:r></w:p>'
      end

      def acronym(opts)
        opts[:block] = true
        opts[:title] ? "#{opts[:text]}(#{opts[:title]})" : "#{opts[:text]}"
      end

      def caps(opts)
        "#{opts[:text]}"
      end

      # simple list with dashes
      [:ol, :ul].each do |m|
        define_method("#{m}_open") do |opts|
          opts[:block] = true
          opts[:nest] > 1 ? "\n" : ""
        end
        define_method("#{m}_close") do |opts|
          ""
        end
      end
      def li_open(opts)
        @li_need_closing = true
        num = opts[:nest] - 1
        "#{"  " * (num > 0 ? num : 0)}- #{opts[:text]}"
      end
      def li_close(opts=nil)
        # avoid multiple line breaks when closing multiple list items
        output = @li_need_closing ? "\n" : ""
        @li_need_closing = false
        output
      end
      def dl_open(opts)
        opts[:block] = true
        ""
      end
      def dl_close(opts=nil)
        ""
      end
      def dt(opts)
        "#{opts[:text]}:\n"
      end
      def dd(opts)
        "  #{opts[:text]}\n"
      end

      # don't render tables
      [:td, :tr_open, :tr_close, :table_open, :table_close].each do |m|
        define_method(m) do |opts|
          ""
        end
      end

      # just add newlines before blockquotes
      #[:bc_open, :bq_open].each do |m|
      #  define_method(m) do |opts|
      #    opts[:block] = true
      #    "QQQQQQ"
      #  end
      #end

      def bc_open(opts)
        opts[:block] = true
        opts[:bc] = true
        ""
      end
      def bc_close(opts)
        ""
      end

      def bq_open(opts)
        opts[:block] = true
        opts[:bq] = true
        ""
      end
      def bq_close(opts)
        ""
      end

      # render link name followed by <url>
      # uses !LINK_OPEN_TAG! and !LINK_CLOSE_TAG! as a way to identify
      # the < > otherwise they will be stripped when all html tags are stripped
      #
      def link(opts)
        "#{opts[:name]} !LINK_OPEN_TAG!#{opts[:href]}!LINK_CLOSE_TAG!"
      end

      # render image alternative text or title if not available
      def image(opts)
        "#{opts[:alt] || opts[:title]}"
      end

      # don't render footnotes
      [:footno, :fn].each do |m|
        define_method(m) do |opts|
          ""
        end
      end

      def snip(opts)
        opts[:text] + "\n"
      end

      # render unescaped quotes and special chars
      def quote1(opts)
        "'#{opts[:text]}'"
      end
      def quote2(opts)
        "\"#{opts[:text]}\""
      end
      def multi_paragraph_quote(opts)
        "\"#{opts[:text]}"
      end
      def ellipsis(opts)
        "#{opts[:text]}..."
      end
      {
          :emdash     => "-",
          :endash     => " - ",
          :arrow      => "->",
          :trademark  => "™",
          :registered => "®",
          :copyright  => "©",
          :amp        => "&",
          :gt         => ">",
          :lt         => "<",
          :br         => "\n",
          :quot       => "\"",
          :squot      => "'",
          :apos       => "'",
      }.each do |method, output|
        define_method(method) do |opts|
          output
        end
      end
      def dim(opts)
        opts[:text]
      end
      def entity(opts)
        unescape("&#{opts[:text]};")
      end

      # strip HTML tags
      def html(opts)
        strip_tags(opts[:text]) + "\n"
      end
      def html_block(opts)
        strip_tags(opts[:text])
      end
      def notextile(opts)
        puts '-------------------- notextile -----------------'
        ooxml_paragraph do
          ooxml_period([]) do
            strip_tags(opts[:text])
          end
        end
      end
      def inline_html(opts)
        strip_tags(opts[:text])
      end

      # unchanged
      def ignored_line(opts)
        opts[:text] + "\n"
      end

      private

      def strip_tags(text)
        Sanitizer.strip_tags(text)
      end

      def unescape(str)
        CGI.unescapeHTML(str.to_s)
      end

      # no escaping
      [:escape, :escape_pre, :escape_attribute].each do |m|
        define_method(m) do |text|
          text
        end
      end
      def after_transform(text)
        puts 'after_transform'
      end
      def before_transform(text)
        puts 'before_transform'
        unless @before_transform
          @before_transform = true
          cahin_m
        end
      end
    end
  end
  class TextileDoc
    def to_ooxml(*rules)
      apply_rules(rules)
      output = to(Formatters::Ooxml)
      #output = Formatters::Plain::Sanitizer.strip_tags(output)
      # replace special link hooks with < and >
      # See #RedCloth::Formatters::Plain#link above
      #output.gsub("!LINK_OPEN_TAG!", "<").gsub("!LINK_CLOSE_TAG!", ">")
    end
  end
end


module RedCloth
  module Formatters
    module Ooxml

      def cahin_m
        fm = singleton_methods.map! {|method| method.to_sym }
        #pp fm.map{|m| m.to_s}.sort

        eigenclass = class << self; self; end

        fm.each do |m|
          real_method_name = (m.to_s + '_real').to_sym
          eigenclass.class_eval %Q{
            alias_method :#{real_method_name}, :#{m}
            def #{m} *o
              @level ||= 0
              @level += 1
              puts ('---' * @level) + "#{real_method_name}"
              ret = send :"#{real_method_name}", *o
              #puts "#{real_method_name}"
              @level -= 1
              return ret
            end
          }

        end
      end

    end
  end
end
