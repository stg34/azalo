class CreateAzOperationTimes < ActiveRecord::Migration
  def self.up
    create_table :az_operation_times do |t|
      t.integer :az_base_data_type_id, :null => false
      t.integer :az_operation_id, :null => false
      t.float   :operation_time
      t.integer :copy_of

      t.timestamps
    end
    
    execute("delete from az_operations")

    ops = [['Создание', 'new'], ['Отображение', 'show'], ['Редактирование', 'edit'], ['Удаление', 'delete']]
    ops.each do |op|
      execute("insert into az_operations (name, crud_name, created_at, updated_at) values ('#{op[0]}', '#{op[1]}', now(), now());")
    end

    ops = AzOperation.all
    sdts = AzSimpleDataType.all

    ops.each do |op|
      sdts.each do |sdt|
        execute("insert into az_operation_times (az_base_data_type_id, az_operation_id, operation_time, created_at, updated_at)
                     values (#{sdt.id}, #{op.id}, 1, now(), now())")

      end

      #execute("insert into az_operation_times (az_base_data_type_id, az_operation_id, operation_time, created_at, updated_at)
      #             select az_base_data_types.id, az_operations.id, az_base_data_types.#{op[1]}_task_time, now(), now() from
      #                 az_operations, az_base_data_types where az_operations.name='#{op[1]}'")
    end

  end

  def self.down
    drop_table :az_operation_times
  end
end
