xml.instruct! :xml, :version=>'1.0', :encoding => 'UTF-8'

xml.Relationships 'xmlns' => 'http://schemas.openxmlformats.org/package/2006/relationships' do
  xml.Relationship 'Id' => 'rId1', 'Type' => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles', 'Target' => 'styles.xml'
  xml.Relationship 'Id' => 'rId2', 'Type' => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/header', 'Target' => 'header1.xml'
  xml.Relationship 'Id' => 'rId3', 'Type' => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer', 'Target' => 'footer1.xml'
  xml.Relationship 'Id' => 'rId4', 'Type' => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/numbering', 'Target' => 'numbering.xml'
  xml.Relationship 'Id' => 'rId5', 'Type' => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/fontTable', 'Target' => 'fontTable.xml'

  image_list.each do |image_entry|
    image_rel_id = image_entry[1]
    image_file_name = image_entry[2]
    xml.Relationship 'Id' => "#{image_rel_id}", 'Type' => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image', 'Target' => "media/#{image_file_name}"
  end
end



