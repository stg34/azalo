require 'rubygems'
require 'nokogiri'
require 'state_machine'
require 'test_helper'

load "#{RAILS_ROOT}/lib/xml_generator.rb"
#require 'helpers/ooxml_builder_helper'
#require 'red_cloth_formatters_ooxml'
#require 'equivalent-xml'

#include OoxmlBuilderHelper

class RedclothFormattersTest < ActiveSupport::TestCase

  Fixtures_root = RAILS_ROOT + '/test/fixtures/textile_ooxml/'

  #---------------------------------------------------------------------------
  test 'Test ooxml * 1' do

    docx_generator = DocxGenerator.new

    StateMachine::Machine.draw('DocxGenerator', :file => 'test/unit/xml_generator.rb')

    events = ''
    xmls = '<p>text1 <strong><em>em and strong</em> strong</strong> text2</p>'
    Nokogiri::XML::Reader(xmls).each do |n|
      #puts "#{n.name} ---> #{n.value} ----> #{n.node_type}"

      event = nil
      if n.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
        event = (n.name.to_s + '_start').to_sym
      elsif n.node_type == Nokogiri::XML::Reader::TYPE_END_ELEMENT
        event = (n.name.to_s + '_end').to_sym
      elsif n.node_type == Nokogiri::XML::Reader::TYPE_TEXT
        docx_generator.text = n.value
        event = :text
      end
      if event
        #puts "event: #{event}"
        events << "event: #{event}\n"
        docx_generator.fire_state_event(event)
      end
    end

    puts events


    #puts docx_generator.state
    #docx_generator.text = '---TEST---'

    #puts docx_generator.p_start
    #puts docx_generator.state
    #puts docx_generator.p_end
    #puts docx_generator.state

    #puts vehicle = Vehicle.new           # => #<Vehicle:0xb7cf4eac @state="parked", @seatbelt_on=false>
    #puts vehicle.state                   # => "parked"
    #puts vehicle.state_name              # => :parked
    #puts vehicle.human_state_name        # => "parked"
    #puts vehicle.parked?                 # => true
    #puts vehicle.can_ignite?             # => true
    #puts vehicle.ignite_transition       # => #<StateMachine::Transition attribute=:state event=:ignite from="parked" from_name=:parked to="idling" to_name=:idling>
    #puts vehicle.state_events            # => [:ignite]
    #puts vehicle.state_transitions       # => [#<StateMachine::Transition attribute=:state event=:ignite from="parked" from_name=:parked to="idling" to_name=:idling>]
    #puts vehicle.speed                   # => 0
    #puts vehicle.moving?                 # => false

    #assert_not_nil ActionController::Base.helpers
    #assert_not_nil defined?(ActionController::Base.helpers.ooxml_period)

    text = 'ЖИРНОТА'
    output = "*#{text}*"


    #assert_equal output, "<w:p><w:pPr></w:pPr><w:r><w:rPr><w:b/><w:bCs/></w:rPr><w:t>#{text}</w:t></w:r></w:p>"
  end
  # ---------------------------------------------------------------------------

end
