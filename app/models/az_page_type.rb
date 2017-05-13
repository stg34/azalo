# TODO где проверка owner?
class AzPageType < ActiveRecord::Base
  # set_table_name "az_base_data_types"
  self.table_name = 'az_base_data_types'

  # TODO эта таблица связывает отношением многие-ко-многим таипы и страницы.
  # Может ли один тип принадлежать страницам из разных проектов?

  def self.find_all_page_types(company)
    AzPageType.find(:all, :conditions => {:owner_id => company.id}).sort{|a, b| a.name <=> b.name } # TODO sort in DB
  end

  def self.page_types_with_collections(all_data_types)
    data_type_list = all_data_types.select { |dt| dt.class != AzCollectionDataType }
    data_type_list.sort!{|a, b| a.name <=> b.name}
    collection_data_type_list = all_data_types.select { |dt| dt.class == AzCollectionDataType }

    dataTypeWithCollections = Struct.new(:data_type, :collections)

    data_type_list_with_collections = []


    data_type_list.each do |dt|
      dtwc = dataTypeWithCollections.new(dt, [])

      #data_type_list_with_collections = [dt =>[] ]
      collection_data_type_list.each do |cdt|
        if cdt.az_base_data_type.id == dt.id
          #data_type_list_with_collections[dt] << cdt
          dtwc.collections << cdt
        end
      end
      data_type_list_with_collections << dtwc
    end
    puts data_type_list_with_collections.inspect
    return data_type_list_with_collections
  end

end

