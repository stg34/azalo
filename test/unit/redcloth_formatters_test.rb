require 'rubygems'
require 'docx_test_helper'
#require 'helpers/ooxml_builder_helper'
require 'red_cloth_formatters_ooxml'
require 'equivalent-xml'

#load "#{RAILS_ROOT}/lib/red_cloth_formatters_ooxml.rb"

#include OoxmlBuilderHelper

def normalize_xml(doc, ignore_nodes, ignore_attrs)
  ignore_attrs.each_pair do |node_selector, attrs|
    attrs.each do |attr|
      path = "#{node_selector}[@#{attr}]"
      doc.xpath(path).each do |node|
        node.remove_attribute(attr.split(':').last)
      end
    end
  end

  ignore_nodes.each do |node_selector|
    doc.xpath(node_selector).each do |node|
      node.remove
    end
  end
end

class RedclothFormattersTest < ActiveSupport::TestCase

  Fixtures_root = RAILS_ROOT + '/test/fixtures/textile_ooxml/'

  # ---------------------------------------------------------------------------
 # test 'Test ooxml * 1' do
 #
 #   assert_not_nil ActionController::Base.helpers
 #   assert_not_nil defined?(ActionController::Base.helpers.ooxml_period)
 #
 #   text = 'ЖИРНОТА'
 #   input = "*#{text}*"
 #   output = ooxml_textile_text do
 #     input
 #   end
 #
 #   assert_equal output, "<w:p><w:pPr></w:pPr><w:r><w:rPr><w:b/><w:bCs/></w:rPr><w:t>#{text}</w:t></w:r></w:p>"
 # end
 # # ---------------------------------------------------------------------------
 # test 'Test ooxml _ 1' do
 #
 #   assert_not_nil ActionController::Base.helpers
 #   assert_not_nil defined?(ActionController::Base.helpers.ooxml_period)
 #
 #   text = 'НАКЛОНОТА'
 #   input = "_#{text}_"
 #   output = ooxml_textile_text do
 #     input
 #   end
 #
 #   assert_equal output, "<w:p><w:pPr></w:pPr><w:r><w:rPr><w:i/><w:iCs/></w:rPr><w:t>#{text}</w:t></w:r></w:p>"
 # end
 # # ---------------------------------------------------------------------------
 # test 'Test ooxml *_ 1' do
 #
 #   assert_not_nil ActionController::Base.helpers
 #   assert_not_nil defined?(ActionController::Base.helpers.ooxml_period)
 #
 #   text = 'ЖИРНОТА НАКЛОНОТА'
 #   input = "*_#{text}_*"
 #   output = ooxml_textile_text do
 #     input
 #   end
 #
 #   assert EquivalentXml.equivalent?("<w:p><w:pPr></w:pPr><w:r><w:rPr><w:b/><w:bCs/><w:i/><w:iCs/></w:rPr><w:t>#{text}</w:t></w:r></w:p>", output)
 #end
 # # ---------------------------------------------------------------------------
 # test 'Test ooxml _* 2' do
 #
 #   assert_not_nil ActionController::Base.helpers
 #   assert_not_nil defined?(ActionController::Base.helpers.ooxml_period)
 #
 #   text = 'ЖИРНОТА НАКЛОНОТА'
 #   input = "_*#{text}*_"
 #   output = ooxml_textile_text do
 #     input
 #   end
 #
 #   puts output
 #   puts input
 #
 #   assert EquivalentXml.equivalent?("<w:p><w:pPr></w:pPr><w:r><w:rPr><w:b/><w:bCs/><w:i/><w:iCs/></w:rPr><w:t>#{text}</w:t></w:r></w:p>", output)
 # end

  test 'Test fixtures/basic' do

    #StateMachine::Machine.draw('DocxGenerator', :file => 'lib/docx_generator.rb')

    fixture_name = 'basic'
    fixture_file_name = Fixtures_root + fixture_name + '.yml'
    #YAML.load(fixture_file_name)

    File.open(fixture_file_name) do |yf|
      YAML.load_documents(yf) do |ydoc|
        puts '-----------'
        puts ydoc['name']
        puts ydoc['desc'] if ydoc['desc']
        if ydoc['fixme']
          puts 'FIXME -------------------------------------------------------------------------------------'
          puts ydoc['fixme']
          puts 'FIXME -------------------------------------------------------------------------------------'
        end

        if ydoc['skip']
          puts 'SKIPPED TEST ----- SKIPPED TEST ----- SKIPPED TEST ----- SKIPPED TEST ----- SKIPPED TEST'
          puts ydoc['name']
          puts ydoc['skip']
          puts 'SKIPPED TEST ----- SKIPPED TEST ----- SKIPPED TEST ----- SKIPPED TEST ----- SKIPPED TEST'
          next
        end


        rc = RedCloth.new(ydoc['in'])
        intermediate_oo_xml = rc.to_intermediate_oo_xml
        eq = false
        eq = EquivalentXml.equivalent?(ydoc['intermediate_oo_xml'], intermediate_oo_xml) do |n1, n2, result|
          #eq = result
          #unless result
          #  puts ".Error in node1: #{n1.path}" if n1
          #  puts ".Error in node2: #{n2.path}" if n2
          #end
        end
        if eq
          puts "++++++++++ #{ydoc['name']} XML OK ++++++++++"
        else
          puts '------------------------  XML ERROR ------------------------'
          puts '* * * * * * *'
          puts "input: #{ydoc['in']}"
          puts '* * * * * * *'
          puts "sample:    #{ydoc['intermediate_oo_xml']}"
          puts '* * * * * * *'
          puts "generated: #{intermediate_oo_xml}"
          puts '* * * * * * *'
        end
        assert eq

        generator = DocxGenerator.new

        output_oo_document = Nokogiri::XML(generator.parse_imtermediate_xml(intermediate_oo_xml))

        unless ydoc['docx']
          puts '!!!!!!!!!!!!!!!!!!!!!!!! DOCX file is not present !!!!!!!!!!!!!!!!!!!!!!!!'
          next
        end

        sample_docx = Fixtures_root + 'docxes/' + fixture_name + '/' + ydoc['docx']
        sample = Nokogiri::XML(docx_get_file(sample_docx, 'word/document.xml'))

        ignore_attrs = {'//*' => %w(w:rsidR w:rsidRPr w:rsidRDefault w:rsidSect w:rsidP xml:space)}
        ignore_nodes = ['//w:lang', '//w:proofErr', '//w:pPr/w:ind', '//w:pPr/w:spacing', '//w:sectPr']

        normalize_xml(sample, ignore_nodes, ignore_attrs)
        normalize_xml(output_oo_document, ignore_nodes, ignore_attrs)
        eq = EquivalentXml.equivalent?(sample, output_oo_document) do |n1, n2, result|
            unless result
              puts "Error in node1: #{n1.path}"
              puts "Error in node2: #{n2.path}"
            end

        #eq = EquivalentXml.equivalent?(sample, output_oo_document) do |n1, n2, result|
        #  eq = result
        #
        #  # Exclude nodes from comparsion
        #  unless result
        #    if n1
        #      #if n1.node_type == Nokogiri::XML::Reader::TYPE_TEXT
        #      if n1.is_a? String
        #        puts n1
        #      else
        #        puts "Error in node1: #{n1.path}"
        #        #puts n1.inner_text
        #      end
        #    end
        #    if n2
        #      puts "Error in node2: #{n2.path}"
        #      #if n2.node_type == Nokogiri::XML::Reader::TYPE_TEXT
        #      if n2.is_a? String
        #        puts n2
        #      else
        #        puts "Error in node2: #{n2.path}"
        #        #puts n2.inner_text
        #      end
        #    end
        #
        #    if n1 && n2 && n1.is_a?(String) && n2.is_a?(String)
        #      puts '--------'
        #      puts n1.inner_text
        #      puts n2.inner_text
        #      #puts n1.inner_text == n2.inner_text
        #      puts '--------'
        #    end
        #  end
        end

        if eq
          puts "++++++++++ #{ydoc['name']} OOXML OK ++++++++++"
        else
          puts '------------------------  OOXML ERROR ------------------------'
          puts ydoc['docx'][0...'000'.size]
          puts '* * * * * * *'
          puts "input #{intermediate_oo_xml}"
          puts '* * * * * * *'
          #sample_xml = Nokogiri::XML::Document.parse(sample)
          puts "sample:    #{sample.to_s}"
          puts '* * * * * * *'
          puts "generated: #{output_oo_document.to_s}"
          puts '* * * * * * *'
          File.open('/tmp/sample.xml', 'w') { |file| file.write(sample.to_s) }
          File.open('/tmp/generated.xml', 'w') { |file| file.write(output_oo_document.to_s) }
        end
        assert eq

        #pp ydoc
        ## ydoc contains the single object
        ## from the YAML document
      end
    end

  end

  # ---------------------------------------------------------------------------
end
