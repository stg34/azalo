class UpdateTaskIdInRedmine < ActiveRecord::Migration

  def self.connect_db
    retryCount = 0
    begin
      connPool = RM_ActiveRecord.establish_connection(
        :adapter  => 'mysql',
        :host     => 'localhost',
        :port     => 3306,
        :username => 'root',
        :password => '1234567890',
        :database => 'redmine',
        :reconnect => true,
        :encoding => 'utf8'
      )
      db = connPool.checkout()
    rescue => err # for me, always due to dead connection; must retry bunch-o-times to get a good one if this happens
      if(retryCount < RM_ActiveRecord::MAX_RETRIES)
        sleep(1) if(retryCount < RM_ActiveRecord::PAUSE_RETRIES)
        retryCount += 1
        connPool.disconnect!
        retry # start again at begin
      else # too many retries, serious, reraise error and let it fall through as it normally would in Rails.
        raise
      end
    end

    return db

  end

  def self.up
    Authorization.current_user = AzUser.find_by_login('admin')
    db = connect_db()
    result_rows = db.select_all("SELECT id, value, customized_id FROM custom_values where customized_type = 'Issue' and custom_field_id=#{Task_id_custom_field_id}")

    non_zero_values = result_rows.select{|rr| rr['value'] != ''}
    task_ids = non_zero_values.collect{|rr| Integer(rr['value'])}
    custom_values_ids = non_zero_values.collect{|rr| [Integer(rr['id']), Integer(rr['value'])] }

    issues_to_remove = result_rows.select{|rr| rr['value'] == ''}.collect{|rr| Integer(rr['customized_id'])}

    puts task_ids.inspect
    puts 'issues to remove:'
    puts issues_to_remove.inspect
    
    task_id_role_id = {}
    task_ids.each do |tid|
      task = AzTask.find(tid)
      puts "#{tid} - #{task.id}"
      task_id_role_id[tid] = task.az_rm_role_id
    end

    custom_values_ids.each do |pp|
      
      custom_value_id = pp[0]
      task_id = pp[1]
      role_id = task_id_role_id[task_id]
      puts "update custom_values set value = #{role_id} where id = #{custom_value_id}"
      db.execute "update custom_values set value = #{role_id} where id = #{custom_value_id}"
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end


class RM_ActiveRecord < ActiveRecord::Base
  PAUSE_RETRIES = 5
  MAX_RETRIES = 50
end