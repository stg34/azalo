
class Hash
  def self.from_xml(xml, preserve_attributes = false)
    # TODO: Refactor this into something much cleaner that doesn't rely on XmlSimple
    typecast_xml_value(undasherize_keys(XmlSimple.xml_in_string(xml,
      'forcearray'   => false,
      'forcecontent' => true,
      'keeproot'     => true,
      'contentkey'   => '__content__')
    ), preserve_attributes)
  end

  private

    def self.typecast_xml_value(value, preserve_attributes = false)
      case value.class.to_s
        when 'Hash'
          if value['type'] == 'array'
            child_key, entries = value.detect { |k,v| k != 'type' }   # child_key is throwaway
            if entries.nil? || (c = value['__content__'] && c.blank?)
              []
            else
              case entries.class.to_s   # something weird with classes not matching here.  maybe singleton methods breaking is_a?
              when "Array"
                entries.collect { |v| typecast_xml_value(v, preserve_attributes) }
              when "Hash"
                [typecast_xml_value(entries, preserve_attributes)]
              else
                raise "can't typecast #{entries.inspect}"
              end
            end
          elsif value.has_key?("__content__")
            content = value["__content__"]
            if parser = XML_PARSING[value["type"]]
              if parser.arity == 2
                XML_PARSING[value["type"]].call(content, value)
              else
                XML_PARSING[value["type"]].call(content)
              end
            elsif preserve_attributes && value.keys.size > 1
              value["content"] = value.delete("__content__")
              value
            else
              content
            end
          elsif value['type'] == 'string' && value['nil'] != 'true'
            ""
          # blank or nil parsed values are represented by nil
          elsif value.blank? || value['nil'] == 'true'
            nil
          # If the type is the only element which makes it then
          # this still makes the value nil, except if type is
          # a XML node(where type['value'] is a Hash)
          elsif value['type'] && value.size == 1 && !value['type'].is_a?(::Hash)
            nil
          else
            xml_value = value.inject({}) do |h,(k,v)|
              h[k] = typecast_xml_value(v, preserve_attributes)
              h
            end

            # Turn { :files => { :file => #<StringIO> } into { :files => #<StringIO> } so it is compatible with
            # how multipart uploaded files from HTML appear
            xml_value["file"].is_a?(StringIO) ? xml_value["file"] : xml_value
          end
        when 'Array'
          value.map! { |i| typecast_xml_value(i, preserve_attributes) }
          case value.length
            when 0 then nil
            when 1 then value.first
            else value
          end
        when 'String'
          value
        else
          raise "can't typecast #{value.class.name} - #{value.inspect}"
      end
    end
end


module AttributePreservingXmlFormat extend ActiveResource::Formats::XmlFormat
  def self.decode(xml)
    from_xml_data(Hash.from_xml(xml))
  end
end
