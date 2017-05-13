class CreateAzBaseDataTypes < ActiveRecord::Migration
  def self.up
    create_table :az_base_data_types do |t|
      t.string  :name
      t.string  :type
      t.integer :az_base_data_type_id
      t.integer :az_collection_template_id

      t.timestamps
    end


    simple_data_types = ['Строка', 'Текст', 'Целое', 'Вещественное', 'Логическое', 'Дата', 'Время', 'Дата и время', 'Атачмент', 'Двоичные данные', 'Timestamp']
    simple_data_types.each do |sdt|
      execute("insert into az_base_data_types (name, type, created_at, updated_at) values ('#{sdt}', 'AzSimpleDataType', now(), now());")
    end

  end

  def self.down
    drop_table :az_base_data_types
  end
end
