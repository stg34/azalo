require 'rubygems'
require 'nokogiri'

class DocxGenerator

  DocNamecpaces = { 'w' => 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
                    'o' => 'urn:schemas-microsoft-com:office:office',
                    'r' => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
                    'v' => 'urn:schemas-microsoft-com:vml',
                    'w10' => 'urn:schemas-microsoft-com:office:word',
                    'wp' => 'http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing'}

  attr_accessor :text, :em, :strong, :blockquote_count, :blockquote_paragraph_count, :h_count, :paragraph_count

  def initialize
    @blockquote_count = 0
    @blockquote_paragraph_count = 0
    @footnoteref_count = 0
    @cite_count = 0
    @code_count = 0
    #@del_count = 0
    @ins_count = 0
    @footnoteref_num = 0

    @h_count = 0
    @p_count = 0
    super
  end

  def skip_text
    @footnoteref_count > 0
  end

  def parse_imtermediate_xml(xml)

    Nokogiri::XML::Reader(xml).each do |n|
      #puts "#{n.name} ---> #{n.value} ----> #{n.node_type}"

      event = nil
      unless n.name == 'root'

        if n.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
          event = ('event_' + n.name.to_s + '_start').to_sym
        elsif n.node_type == Nokogiri::XML::Reader::TYPE_END_ELEMENT
          event = ('event_' + n.name.to_s + '_end').to_sym
        elsif n.node_type == Nokogiri::XML::Reader::TYPE_TEXT
          self.text = n.value
          event = :event_text
        end
        if event
          #puts "event: #{event}"
          #events << "event: #{event}\n"
          send(event)
        end
      end
    end
    send(:event_finish)
    #fire_state_event(:end_of_document)
    return document.to_s

  end


  def document
    unless @document

      @document = Nokogiri::XML::Document.parse('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
      @document.encoding = 'UTF-8'
      #@document.

      #@document['xmlns:w'] = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'
      w_document = Nokogiri::XML::Node.new('w:document', @document)
      @document << w_document
      DocNamecpaces.each_pair do |k, v|
        @document.root.add_namespace(k, v)
      end

      w_body = Nokogiri::XML::Node.new('w:body', @document)
      w_document << w_body
      @body = w_body
    end
    return @document
  end


  def end_of_document
    @body << (w_sec_ptr << w_type << w_pg_sz << w_pg_mar << w_pg_num_type << w_form_prot << w_text_direction)
  end

  def w_sec_ptr
    #<w:sectPr>
    #  <w:type w:val="nextPage"/>
    #  <w:pgSz w:h="16838" w:w="11906"/>
    #  <w:pgMar w:bottom="1134" w:footer="0" w:gutter="0" w:header="0" w:left="1134" w:right="1134" w:top="1134"/>
    #  <w:pgNumType w:fmt="decimal"/>
    #  <w:formProt w:val="false"/>
    #  <w:textDirection w:val="lrTb"/>
    #</w:sectPr>
    Nokogiri::XML::Node.new('w:sectPr', document)
  end

  def w_type
    #<w:sectPr>
    #  <w:type w:val="nextPage"/>
    #  <w:pgSz w:h="16838" w:w="11906"/>
    #  <w:pgMar w:bottom="1134" w:footer="0" w:gutter="0" w:header="0" w:left="1134" w:right="1134" w:top="1134"/>
    #  <w:pgNumType w:fmt="decimal"/>
    #  <w:formProt w:val="false"/>
    #  <w:textDirection w:val="lrTb"/>
    #</w:sectPr>
    node = Nokogiri::XML::Node.new('w:type', document)
    node['w:val'] = 'nextPage'
    return node
  end

  def w_pg_sz
    #<w:sectPr>
    #  <w:type w:val="nextPage"/>
    #  <w:pgSz w:h="16838" w:w="11906"/>
    #  <w:pgMar w:bottom="1134" w:footer="0" w:gutter="0" w:header="0" w:left="1134" w:right="1134" w:top="1134"/>
    #  <w:pgNumType w:fmt="decimal"/>
    #  <w:formProt w:val="false"/>
    #  <w:textDirection w:val="lrTb"/>
    #</w:sectPr>
    node = Nokogiri::XML::Node.new('w:pgSz', document)
    node['w:h'] = '16838'
    node['w:w'] = '11906'
    return node
  end

  def w_pg_mar
    #<w:sectPr>
    #  <w:type w:val="nextPage"/>
    #  <w:pgSz w:h="16838" w:w="11906"/>
    #  <w:pgMar w:bottom="1134" w:footer="0" w:gutter="0" w:header="0" w:left="1134" w:right="1134" w:top="1134"/>
    #  <w:pgNumType w:fmt="decimal"/>
    #  <w:formProt w:val="false"/>
    #  <w:textDirection w:val="lrTb"/>
    #</w:sectPr>
    node = Nokogiri::XML::Node.new('w:pgMar', document)
    node['w:bottom'] = '1134'
    node['w:footer'] = '0'
    node['w:gutter'] = '0'
    node['w:header'] = '0'
    node['w:left'] = '1134'
    node['w:right'] = '1134'
    node['w:top'] = '1134'
    return node
  end

  def w_pg_num_type
    #<w:sectPr>
    #  <w:type w:val="nextPage"/>
    #  <w:pgSz w:h="16838" w:w="11906"/>
    #  <w:pgMar w:bottom="1134" w:footer="0" w:gutter="0" w:header="0" w:left="1134" w:right="1134" w:top="1134"/>
    #  <w:pgNumType w:fmt="decimal"/>
    #  <w:formProt w:val="false"/>
    #  <w:textDirection w:val="lrTb"/>
    #</w:sectPr>
    node = Nokogiri::XML::Node.new('w:pgNumType', document)
    node['w:fmt'] = 'decimal'
    return node
  end

  def w_form_prot
    #<w:sectPr>
    #  <w:type w:val="nextPage"/>
    #  <w:pgSz w:h="16838" w:w="11906"/>
    #  <w:pgMar w:bottom="1134" w:footer="0" w:gutter="0" w:header="0" w:left="1134" w:right="1134" w:top="1134"/>
    #  <w:pgNumType w:fmt="decimal"/>
    #  <w:formProt w:val="false"/>
    #  <w:textDirection w:val="lrTb"/>
    #</w:sectPr>
    node = Nokogiri::XML::Node.new('w:formProt', document)
    node['w:val'] = 'false'
    return node
  end

  def w_text_direction
    #<w:sectPr>
    #  <w:type w:val="nextPage"/>
    #  <w:pgSz w:h="16838" w:w="11906"/>
    #  <w:pgMar w:bottom="1134" w:footer="0" w:gutter="0" w:header="0" w:left="1134" w:right="1134" w:top="1134"/>
    #  <w:pgNumType w:fmt="decimal"/>
    #  <w:formProt w:val="false"/>
    #  <w:textDirection w:val="lrTb"/>
    #</w:sectPr>
    node = Nokogiri::XML::Node.new('w:textDirection', document)
    node['w:val'] = 'lrTb'
    return node
  end


  def w_spacing(before, after)
    #<w:spacing w:after="283" w:before="0"/>
    node = Nokogiri::XML::Node.new('w:spacing', document)
    node['w:after'] = after.to_s
    node['w:before'] = before.to_s
    return node
    #<w:ind w:hanging="0" w:left="567" w:right="567"/>
  end
  def w_p_ind(hanging, left, right)
    #<w:ind w:hanging="0" w:left="567" w:right="567"/>
    node = Nokogiri::XML::Node.new('w:ind', document)
    node['w:hanging'] = hanging.to_s
    node['w:left'] = left.to_s
    node['w:right'] = right.to_s
    return node
  end
  def w_body
    unless @body
      self.document
    end
    return @body
  end

  def w_p_pr
    #<w:pPr>
    node = Nokogiri::XML::Node.new('w:pPr', document)
    return node
  end

  def w_b
    #<w:b/>
    Nokogiri::XML::Node.new('w:b', document)
  end

  def w_i
    #<w:i/>
    Nokogiri::XML::Node.new('w:i', document)
  end

  def w_strike
    #<w:i/>
    Nokogiri::XML::Node.new('w:strike', document)
  end

  def w_p_style(style)
    # <w:pStyle w:val="style0"/>
    node = Nokogiri::XML::Node.new('w:pStyle', document)
    node['w:val'] = style
    return node
  end

  def w_r
    #<w:r>
    return Nokogiri::XML::Node.new('w:r', document)
  end

  def w_r_style(style)
    node = Nokogiri::XML::Node.new('w:rStyle', document)
    node['w:val'] = style
    return node
    #w:rStyle w:val="a5"/>
  end

  def w_p
    #<w:p>
    Nokogiri::XML::Node.new('w:p', document)
  end


  def w_r_pr
    #<w:rPr/>
    return Nokogiri::XML::Node.new('w:rPr', document)
  end

  def w_t
    #<w:t>  ...  </w:t>
    return Nokogiri::XML::Node.new('w:t', document)
  end

  def w_br
    #<w:br/>
    return Nokogiri::XML::Node.new('w:br', document)
  end

  def w_text(txt)
    return Nokogiri::XML::Text.new(txt, document)
  end


  def w_num_pr
    return Nokogiri::XML::Node.new('w:numPr', document)
  end


  def footnote_reference(id)
    node = Nokogiri::XML::Node.new('w:footnoteReference', document)
    node['w:id'] = id.to_s
    return node
    #<w:footnoteReference w:id="2"/>
  end

  def w_ilvl(lvl)
    node = Nokogiri::XML::Node.new('w:ilvl', document)
    node['w:val'] = lvl.to_s
    return node
  end

  def w_num_id(id)
    node = Nokogiri::XML::Node.new('w:numId', document)
    node['w:val'] = id.to_s
    return node
  end

  def event_p_start

    if blockquote_count > 0
      @blockquote_paragraph_count += 1
      @paragraph = w_p << (w_p_pr << w_p_style('style20'))
    else
      @paragraph = w_p #<< (w_p_pr << w_p_style('style0'))
    end

    w_body << @paragraph
    @p_count += 1
  end

  def event_p_end

  end

  def event_pre_start
    @paragraph = w_p << (w_p_pr << w_p_style('style20'))
    #w_body << @paragraph
  end

  def event_pre_end

  end

  def event_cite_start
    @cite_count += 1
  end

  def event_cite_end
    @cite_count -= 1
  end

  def event_code_start
    @code_count += 1
  end

  def event_code_end
    @code_count -= 1
  end

  def event_del_start
    @strike = 'strike'
  end

  def event_del_end
    @strike = nil
  end

  def event_ins_start
    @ins_count += 1
  end

  def event_ins_end
    @ins_count -= 1
  end

  def event_blockquote_start
    @blockquote_count += 1
  end

  def event_ol_start

  end

  def event_ol_end

  end

  def event_li_start

  end

  def event_li_end

  end

  def event_blockquote_end
    @blockquote_count -= 1
    @blockquote_paragraph_count = 0

    p_pr = nil
    @paragraph.element_children.each{|e| p_pr = e if e.name == 'w:pPr' }
    if p_pr
      p_pr << w_p_ind(0, 567, 567) << w_spacing(0, 283)
    end

  end

  def event_finish
    end_of_document
  end


  #def split_text_into_run_textes(text)
  #  {:text => 'text', :text_type => 0}
  #end
  #
  #def split_text_to_periods(text)
  #  marker_positions_begin = []
  #  marker_positions_end = []
  #
  #  i = -1
  #  n = 0
  #  while i = text.index(PeriodWrapMarkerBegin, i + 1)
  #    marker_positions_begin[n] = i
  #    n += 1
  #  end
  #
  #  i = -1
  #  n = 0
  #  while i = text.index(PeriodWrapMarkerEnd, i + 1)
  #    marker_positions_end[n] = i + PeriodWrapMarkerEnd.size
  #    n += 1
  #  end
  #
  #  marker_positions = marker_positions_begin.zip(marker_positions_end)
  #
  #  period_textes = []
  #
  #  marker_positions.flatten!
  #  marker_positions << text.size
  #  marker_positions.insert(0, 0)
  #  marker_positions.uniq!
  #
  #  marker_positions.each_with_index do |pos, i|
  #
  #    next if i == 0
  #
  #    period = text[marker_positions[i-1]...marker_positions[i]]
  #
  #    if period.start_with?(PeriodWrapMarkerBegin) && period.end_with?(PeriodWrapMarkerEnd)
  #      idx1 = period.index('[')
  #      idx2 = period.index(']')
  #      period_styles = period[idx1+1...idx2]
  #      period = period[idx2+1...period.size - PeriodWrapMarkerEnd.size]
  #      period_textes << [period, period_styles.split(',').map{|s| s.to_sym}]
  #    else
  #      period_textes << [period, []]
  #    end
  #  end
  #  return period_textes
  #end


  def event_footnoteref_start
    @footnoteref_count += 1
    @footnoteref_num += 1
  end

  def event_footnoteref_end
    @footnoteref_count -= 1
  end

  def event_text
    if @paragraph

      # Add line break into the run

      textes = text.split(RedCloth::Formatters::IntermediateOOXml::BreakStr)
      textes.each_with_index do |txt, i|

        run = w_r
        @paragraph << run

        if @footnoteref_count == 1
          run << (w_r_pr << w_r_style('a5'))
          run << footnote_reference(@footnoteref_num + 1)
        end

        if @cite_count == 1
          run << (w_r_pr << w_r_style('20'))
          #run << w_text(txt)
        end

        if @code_count == 1
          run << (w_r_pr << w_r_style('20'))
          #run << w_text(txt)
        end

        if @em
          run << (w_r_pr << w_i)
        end

        if @strong
          run << (w_r_pr << w_b)
        end

        if @strike
          run << (w_r_pr << w_strike)
        end

        unless skip_text
          run << (w_t << w_text(txt))
        end
        if i > 0
          run << w_br
        end
      end

    end
  end

  def event_em_start
    @em = 'em'
  end
  alias event_i_start event_em_start

  def event_em_end
    @em = nil
  end
  alias event_i_end event_em_end

  def event_strong_start
    @strong = 'strong'
  end
  alias event_b_start event_strong_start

  def event_strong_end
    @strong = nil
  end
  alias event_b_end event_strong_end

  #<w:p>
  #  <w:pPr>
  #    <w:pStyle w:val="style3"/>
  #    <w:numPr>
  #      <w:ilvl w:val="2"/>
  #      <w:numId w:val="1"/>
  #    </w:numPr>
  #    <w:spacing w:after="120" w:before="240"/>
  #  </w:pPr>
  #  <w:r>
  #    <w:rPr/>
  #    <w:t>Header 3</w:t>
  #  </w:r>
  #</w:p>

  (1..6).each do |m|
    hs = "event_h#{m}_start".to_sym
    he = "event_h#{m}_end".to_sym
    define_method(hs) do
      @h_count += 1
      if @h_count == 1 && @p_count == 0
        @paragraph = w_p << (w_p_pr << w_p_style("style#{m}")  << (w_num_pr << w_ilvl(m-1) << w_num_id(1)) << w_spacing(240, 120))
      else
        @paragraph = w_p << (w_p_pr << w_p_style("style#{m}")  << (w_num_pr << w_ilvl(m-1) << w_num_id(1)))
      end
      w_body << @paragraph
    end
    define_method(he) do

    end
  end

  def event_br_start

  end

  def event_br_end

  end


end
