#task :greet do
#   puts "Hello world"
#end

namespace :content  do
  desc "create some fake data"

  task :fix_content => :environment do
    #ActiveRecord::Base.connection.execute('update az_validators set description="Строка должна соответствовать телефонному номеру. Например + 1 (23) 456-78-90 или 11-22-33"  WHERE description="Строка должна соответсвовать телефонному номеру. Например + 1 (23) 456-78-90 или 11-22-33"')
    #ActiveRecord::Base.connection.execute('update az_validators set description="Строка должна соответствовать формату email. Например: foobar@example.com"  WHERE description="Строка должна соответсвовать формату email. Например: foobar@example.com"')
    #ActiveRecord::Base.connection.execute('update az_validators set description="Строка должна соответствовать формату URL. Например: http://example.com/foo/bar.html"  WHERE description="Строка должна соответсвовать формату URL. Например: http://example.com/foo/bar.html"')
    #ActiveRecord::Base.connection.execute('update az_validators set description="Запись не должна повторяться"  WHERE description="Запись не должна поворяться"')

    #ActiveRecord::Base.connection.execute('update az_tr_texts set text="На странице необходимо отобразить %collection_name%.\r\n\r\nОтображаться должны следующие столбцы:\r\n\r\n%variable_list%" where text="На странице необходимо отобразить %data_type_name%.\r\n\r\nОтображаться должны следующие столбцы:\r\n\r\n%variable_list%"')
    #ActiveRecord::Base.connection.execute('UPDATE az_validators SET message = REPLACE(message, "Зпасись", "Запись");')


    puts "============================================================="

    Authorization.current_user = AzUser.find_by_login('admin')
    trts = AzTrText.find(:all, :conditions => {:seed => true})
    if trts.size == 0
      puts 'Empty tr_texts'
      break
    end
    trts.each do |trt|
      puts "update #{trt.id} #{trt.name} #{trt.owner_id}"
      #ActiveRecord::Base.connection.execute("update az_tr_texts set name = '#{trt.name}', text = '#{trt.text}' az_operation_id = #{trt.az_operation_id} data_type = #{trt.data_type} where copy_of=#{trt.id}")

      op_id = trt.az_operation_id ? trt.az_operation_id : 'NULL'
      data_type = trt.data_type ? trt.data_type : 'NULL'

      st = ActiveRecord::Base.connection.raw_connection.prepare("update az_tr_texts set name=?, text=?, az_operation_id=#{op_id}, data_type=#{data_type} where copy_of=#{trt.id}")
      st.execute("#{trt.name}", "#{trt.text}")
      st.close

    end

    all_companies = AzCompany.find(:all)
    all_companies.each do |cmp|
      puts cmp.id
      comp = AzCompany.find(cmp.id, :include => :tr_texts)
      if comp.ceo.never_visited == true || comp.id == 2
        puts "#{comp.name}. CEO #{comp.ceo.login} never visited"
      else

        text_ids = comp.tr_texts.collect{|v| v.copy_of}
        trts.each do |trt|
          #puts "update #{com.id} #{com.name} #{com.owner_id}"

          if !text_ids.include?(trt.id)
            puts "trt.make_copy(c) ------------------------------ ceo: #{comp.ceo.login}"
            trt.make_copy(comp)
          end

        end
      end
    end

  end
end


