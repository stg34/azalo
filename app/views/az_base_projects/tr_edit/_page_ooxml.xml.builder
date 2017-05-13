embedded_pages = page.get_embedded_pages1
designs = page.get_designs

ooxml_h2 do
  h(page.name)
end

ooxml_simple_text_paragraph do
  h(page.description)
end

embedded_pages.each do |p|
  ooxml_simple_text_paragraph do
    h(p.description)
  end
end

ooxml_simple_text_paragraph do
  "#{t(:az_label_page_title)}: #{h(page.title)}"
end



designs.each do |design|
  design.az_images.each do |image|
    ext = File.extname(image.image.path)
    image_file_name_in_doc = "tr_image#{image.id}#{ext}"
    image_rel_id = "tr_image#{image.id}"

    image_list << [image.image.path, image_rel_id, image_file_name_in_doc]

    #ooxml_picture(image_rel_id, image.image.path)

    ooxml_simple_text_paragraph do
      #File.extname(image.description)
      'Description'
    end
  end
end
