require 'rubygems'
require 'active_resource'

class RM_ActiveRecord < ActiveRecord::Base
  PAUSE_RETRIES = 5
  MAX_RETRIES = 50
end

class RM_ActiveResource < ActiveResource::Base
  self.site = 'http://localhost:3001/'
  self.user = 'admin'
  self.password = 'AWDwRthw'
end

class RMIssue < RM_ActiveResource

  def initialize(user, args)
    if user != nil
      #puts user.inspect
      #puts user.login
      #puts self.class.user
      #puts self.class.password
      self.class.user = user.login
      self.class.password = user.crypted_password + "KupOsyitoc"
    end
    super(args)
  end

  self.element_name = 'issue'
end

class RMProject < RM_ActiveResource
  self.element_name = 'project'
end


class RMRegUser < RM_ActiveResource
  self.element_name = 'project'
end

class RedmineIntegrator

  #Page_id_custom_field_id = 3;
  #Task_id_custom_field_id = 4;

  def initialize(user = nil)
    @user = user
  end

  def connect_db
    retryCount = 0
    begin
      connPool = RM_ActiveRecord.establish_connection(
        :adapter  => 'mysql',
        :host     => 'localhost',
        :port     => 3306,
        :username => 'root',
        :password => '123456',
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

  def get_str_error
    return @str_error
  end

  def reg_user(login, password)
    begin
      RMRegUser.user = login
      RMRegUser.password = password
      RMRegUser.find(:all)
    rescue
      #TODO
    end
  end

  def find_all_projects
    RMProject.find(:all)
  end

  def find_project(id)
    #project = RMProject.find(id)
    db = connect_db()
    id = Integer(id)
    result_row = db.select_one("SELECT * FROM projects where id=#{id}")
    return result_row
  end

  def get_rm_user_id_by_login(login)
    db = connect_db()
    # TODO SQL injection
    result_row = db.select_one("SELECT id FROM users where login='#{login}' limit 1")
    puts result_row.inspect

    if result_row
      return Integer(result_row['id'])
    end
    return nil

  end


  def get_rm_user_login_by_id(id)
    if id == nil || id == ''
      return "???"
    end

    db = connect_db()
    # TODO SQL injection
    result_row = db.select_all("SELECT login FROM users where id='#{id}' limit 1")
    return result_row[0]['login']
  end

  def get_anonymous_id
    return 2
  end

  def get_roles(with_builtin = false)
    db = connect_db()

    if with_builtin
      result_rows = db.select_all("SELECT * FROM roles order by position")
    else
      result_rows = db.select_all("SELECT * FROM roles where builtin=0 order by position")
    end

    return result_rows
  end

  def get_role(id)
    db = connect_db()
    id = Integer(id)
    result_row = db.select_one("SELECT * FROM roles where id=#{id} order by position")
    return result_row
  end


  def get_project_by_identifier(identifier)
    db = connect_db()
    result_row = db.select_one("SELECT * FROM projects where identifier='#{identifier}' limit 1")
    return result_row
  end

  def get_role_by_name(role_name)
    db = connect_db()
    result_row = db.select_one("SELECT * FROM roles where name='#{role_name}' limit 1")
    return result_row
  end

  def get_users_by_roles_in_project(rm_project_id)
    # returns array of hashes: [{rm_role_id=>rm_user_id}, {4=>4}, {7=>7}, {3=>1}]
    users_roles = {}
    project = find_project(rm_project_id)
    project['users'] = []
    project['users'] = get_users_in_project(rm_project_id)
    puts "qwe------------------------------------------------------------------------"
    puts project['users'].inspect
    puts "qwe------------------------------------------------------------------------"
    project['users'].each do |user|
      puts user.inspect
      user_id = Integer(user['id'])
      users_roles[user['login']] = get_user_roles_in_project(user_id, rm_project_id)
    end

    roles = users_roles.collect {|ur| ur[1]}
    roles.flatten!
    roles.sort!
    roles.uniq!

    roles_users = {}

    roles.each do |r|
      users = []
      project['users'].each do |user|
        idx = users_roles[user['login']].index(r)
        if idx != nil
          users << user['login']
        end
        roles_users[Integer(r)] = users
      end
    end
    return roles_users
  end

  def get_users_in_project(project_id)
    db = connect_db()
    result = db.select_all("select * from users where id in (SELECT user_id FROM `members` WHERE project_id=#{project_id})")
    return result
  end

  def get_user_roles_in_project(user_id, project_id)
    db = connect_db()
    result_ids = db.select_values("select id from roles where id in (select role_id from member_roles where member_id in (select id from members where project_id=#{project_id} and user_id=#{user_id}))")
    return result_ids
  end

  def add_member_to_project(rm_project_id, rm_user_id, rm_role_id)
    # start transaction
    # INSERT INTO `members` (`created_on`, `project_id`, `user_id`, `mail_notification`) VALUES('2010-07-05 21:18:33', 11, 8, 0)
    # INSERT INTO `member_roles` (`member_id`, `role_id`, `inherited_from`) VALUES(15, 6, NULL)
    # commit transaction

    rm_project_id = Integer(rm_project_id)
    rm_user_id = Integer(rm_user_id)
    rm_role_id = Integer(rm_role_id)
    
    db = connect_db()
    db.transaction()

    #puts "1 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    member_ids = db.select_values("select id from members where project_id = #{rm_project_id} and user_id = #{rm_user_id}")
    #puts member_ids.inspect
    #puts "2 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

    if member_ids.size > 0
      member_id = member_ids[0]
    else
      member_id = db.insert("INSERT INTO `members` (`created_on`, `project_id`, `user_id`, `mail_notification`) VALUES (now(), #{rm_project_id}, #{rm_user_id}, 0)")
    end
    #puts member_id
    #puts "3 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


    #puts "3a +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    member_roles_ids = db.select_values("select id from member_roles where member_id=#{member_id} and role_id=#{rm_role_id}")
    #puts member_ids.inspect
    #puts "3b +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

    if member_roles_ids.size == 0
      #puts "3c +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
      result = db.execute("INSERT INTO `member_roles` (`member_id`, `role_id`, `inherited_from`) VALUES(#{member_id}, #{rm_role_id}, NULL)")
    end
    #puts "4 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    db.commit_db_transaction()
    #puts result.inspect
    #puts "5 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    return result
  end

  def remove_member_role_from_project(project_id, user_id, role_id)
    project_id = Integer(project_id)
    user_id = Integer(user_id)
    role_id = Integer(role_id)

    db = connect_db()
    db.transaction()

    member_ids = db.select_values("select id from members where project_id = #{project_id} and user_id = #{user_id}")
    #puts member_ids.inspect
    puts "0 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

    if member_ids.size > 0
      member_id = member_ids[0]
      puts "1 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
      puts "member_id=" + member_id.to_s
      result = db.execute("delete from member_roles where member_id=#{member_id} and role_id=#{role_id}")

      puts "2 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
      member_roles_ids = db.select_values("select id from member_roles where member_id=#{member_id}")
      puts "3 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

      if member_roles_ids.size == 0
        result = db.execute("delete from members where project_id=#{project_id} and user_id=#{user_id}")
      end
    end
    
    puts "4 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    db.commit_db_transaction()
    #puts result.inspect
    puts "5 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    return result
    
  end

  def clean_role(project_id, role_id)
    # removes all member roles equal to given role
    #delete from member_roles where member_id in(select id from members where project_id=27) and role_id=6;
    project_id = Integer(project_id)
    role_id = Integer(role_id)

    db = connect_db()
    db.transaction()

    result = db.execute("delete from member_roles where member_id in(select id from members where project_id=#{project_id}) and role_id=#{role_id};")
    result = db.execute("delete from members where id not in (select member_id from member_roles where project_id=#{project_id}) and project_id=#{project_id}")

    #puts "4 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    db.commit_db_transaction()

    return result
  end

  def remove_member_from_project(project_id, user_id)

  end

  def enable_issue_tracker(project_id)
    db = connect_db()
    result = db.execute("insert into enabled_modules (project_id, name) values (#{project_id}, 'issue_tracking')")
    #db.commit_db_transaction()
    #
    #result = db.execute("insert into projects_trackers (project_id, tracker_id) values (#{project_id}, 1), (#{project_id}, 2), (#{project_id}, 3);")
    db.commit_db_transaction()
    return result
  end

  def create_project(name, identifier, id)
    #foo = :news
    #puts "------------- create_project -----------------------1"
    #puts name
    #puts id
    #puts "------------- create_project -----------------------2"

    name = name + "-" + id.to_s

    # TODO replace
    #identifier = "project-" + id.to_s
    # with
    #identifier = name + "." + id.to_s
    
    project = RMProject.new(:name => name,
                            :identifier => identifier,
                            :is_public => false)
    #:enabled_modules => ["issue_tracking", "time_tracking", "news"]
    ret = project.save
    #puts "project.id = " + project.inspect
    enable_issue_tracker(project.attributes['id'])
    #puts project.attributes['id'].inspect
    #puts "]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]"
    if ret
      return project.id
    end
    return -1
  end

  def remove_project(rm_id)
    
    begin
      project = RMProject.find(rm_id)
    rescue
      return -1
    end

    puts "project to remove = " + project.name
    ret = project.destroy
    return ret
  end

  def create_issue(project_id, assigned_to_id, task_title, task_description, estimated_hours, page_id, parent_id, role_id)
    #puts "-------------------- creating new issue -----------------------------"
    #puts "estimated_hours = " + estimated_hours.to_s
    #puts Task_id_custom_field_id.to_s

    if parent_id != nil
      issue = RMIssue.new(@user,
                          :subject => task_title,
                          :description => task_description,
                          :assigned_to_id => assigned_to_id,
                          :project_id => project_id,
                          :tracker_id=>'1',
                          :estimated_hours => estimated_hours,
                          :custom_field_values=>{Page_id_custom_field_id.to_s => "page-" + page_id.to_s, Task_id_custom_field_id.to_s => role_id.to_s},
                          :parent_issue_id => parent_id)
    else
      if page_id != nil
        issue_page_id = "page-" + page_id.to_s
      else
        issue_page_id = nil
      end
      issue = RMIssue.new(@user,
                          :subject => task_title,
                          :description => task_description,
                          :assigned_to_id => assigned_to_id,
                          :project_id => project_id,
                          :tracker_id=>'1',
                          :estimated_hours => estimated_hours,
                          :custom_field_values=>{Page_id_custom_field_id.to_s => issue_page_id, Task_id_custom_field_id.to_s => role_id.to_s})
    end
    #, :custom_field_values=>{"3"=>page_id.to_s}
    begin
      ret = issue.save
    rescue
      ret = false
    end

    if ret
      issue_id = issue.id
      puts issue_id
      return Integer(issue.id)
    else
      puts issue.errors.full_messages
    end
    return -1
  end

  def get_issues(project_id)
    #http://localhost:3001/issues.xml?project_id=12&tracker_id=1
    issues = RMIssue.find(:all, :params => {:project_id=>project_id.to_s, :tracker_id=>'1'})
    return issues
  end

  def get_page_issues(page_id)

    page_id = Integer(page_id)
    
    #select * from issues where id in (select customized_id from custom_values where custom_field_id = 3 and value = 'page-#{page_id}');
    #custom_field_id = 3;
    db = connect_db()


    result_rows = db.select_all("SELECT issues.*, custom_values.value as task_id FROM issues
        left JOIN custom_values ON issues.id=custom_values.customized_id and custom_values.custom_field_id = #{Task_id_custom_field_id}
        WHERE issues.id in (select customized_id from custom_values where custom_field_id = #{Page_id_custom_field_id} and value = 'page-#{page_id}')")

#    if task_id == nil
#      result_rows = db.select_all("select * from issues where id in (select customized_id from custom_values where custom_field_id = #{Page_id_custom_field_id} and value = 'page-#{page_id}')")
#    else
#      result_rows = db.select_all(
#        "select * from issues where id in (
#             select customized_id from custom_values where customized_id in (
#                 select customized_id from custom_values where custom_field_id = #{Page_id_custom_field_id} and value = 'page-#{page_id}') and custom_field_id = #{Task_id_custom_field_id} and value = #{task_id})")
#    end
    #puts "================================= get_page_issues(#{page_id})"
    #puts result_rows.inspect
    return result_rows
  end

  def get_pages_issues(page_ids, task_types = nil)

    page_ids = page_ids.collect{|pi| Integer(pi)}

    #select * from issues where id in (select customized_id from custom_values where custom_field_id = 3 and value = 'page-#{page_id}');
    #custom_field_id = 3;
    db = connect_db()

    ins = page_ids.collect{|pi| "'page-#{pi}'" }
    ins = ins.join(',')
    if ins == ""
      ins = "'page--1'"
    end

    #puts "7777777777777777777777777777777777777777777777777777777777777777777777777"
    #puts ins.inspect
    #puts "7777777777777777777777777777777777777777777777777777777777777777777777777"

    str_other_tasks = ""
    task_types_str = "-1"

    all_issues = db.select_all("SELECT i.*, cv1.value as page_id, cv2.value as task_id FROM issues as i
                                 LEFT JOIN custom_values as cv1 ON i.id=cv1.customized_id and cv1.custom_field_id = #{Page_id_custom_field_id}
                                 LEFT JOIN custom_values as cv2 ON i.id=cv2.customized_id and cv2.custom_field_id = #{Task_id_custom_field_id}
                                 where cv1.value in (#{ins})")

    if task_types && task_types.size > 0
      task_types_str = task_types.join(',')
      if task_types.include?(-1)
        str_other_tasks = " or cv2.value is NULL"
      end
    end

#    puts "SELECT i.*, cv1.value as page_id, cv2.value as task_id FROM issues as i
#                                 LEFT JOIN custom_values as cv1 ON i.id=cv1.customized_id and cv1.custom_field_id = #{Page_id_custom_field_id}
#                                 LEFT JOIN custom_values as cv2 ON i.id=cv2.customized_id and cv2.custom_field_id = #{Task_id_custom_field_id}
#                                 where cv1.value in (#{ins}) and (cv2.value in (#{task_types_str}) #{str_other_tasks})"

    filtered_issues = db.select_all("SELECT i.*, cv1.value as page_id, cv2.value as task_id FROM issues as i
                                 LEFT JOIN custom_values as cv1 ON i.id=cv1.customized_id and cv1.custom_field_id = #{Page_id_custom_field_id}
                                 LEFT JOIN custom_values as cv2 ON i.id=cv2.customized_id and cv2.custom_field_id = #{Task_id_custom_field_id}
                                 where cv1.value in (#{ins}) and (cv2.value in (#{task_types_str}) #{str_other_tasks})")

    #result_rows = db.select_all("SELECT issues.*, custom_values.value as task_id FROM issues
    #    left JOIN custom_values ON issues.id=custom_values.customized_id
    #    WHERE issues.id in (select customized_id from custom_values where custom_field_id = #{Page_id_custom_field_id} and value in (#{ins}) ) and custom_field_id = #{Page_id_custom_field_id}")

#    if task_id == nil
#      result_rows = db.select_all("select * from issues where id in (select customized_id from custom_values where custom_field_id = #{Page_id_custom_field_id} and value = 'page-#{page_id}')")
#    else
#      result_rows = db.select_all(
#        "select * from issues where id in (
#             select customized_id from custom_values where customized_id in (
#                 select customized_id from custom_values where custom_field_id = #{Page_id_custom_field_id} and value = 'page-#{page_id}') and custom_field_id = #{Task_id_custom_field_id} and value = #{task_id})")
#    end
    #puts "================================= get_page_issues(#{page_id})"
    #puts result_rows.inspect
    return all_issues, filtered_issues
  end

  def delete_page_issues(page_id)
    #delete from issues where id in (select customized_id from custom_values where custom_field_id = 3 and value = 'page-#{page_id}');
    #custom_field_id = 3;
    db = connect_db()
    deleted_rows = db.delete("delete from issues where id in (select customized_id from custom_values where custom_field_id = #{Page_id_custom_field_id} and value = 'page-#{page_id}')")
    return deleted_rows
  end

  def get_project_issues(page_id)
    
  end

  def get_issues_total_time(project_id, task_types = nil)
    db = connect_db()
    project_id = Integer(project_id)

    if task_types
      task_types_str = task_types.join(',')

      if task_types.size == 0
        task_types_str = "-1"
      end

      #puts task_types_str + "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

      str_other_tasks = ""
      if task_types.include?(-1)
        str_other_tasks = " or custom_values.value is NULL"
      end

      result = db.select_one("SELECT sum(estimated_hours) FROM issues
                                left JOIN custom_values ON issues.id=custom_values.customized_id and custom_values.custom_field_id = #{Task_id_custom_field_id}
                                WHERE project_id = #{project_id} and (custom_values.value in (#{task_types_str}) #{str_other_tasks})")
      #puts "2a................................................."
    else
      result = db.select_one("select sum(estimated_hours) from issues where project_id=#{project_id}")
      #puts "2b................................................."
    end
    
    #puts "1................................................."
    #puts result.inspect
    if result.to_a[0][1] == nil
      return 0
    end
    return Float(result.to_a[0][1])
  end

  def get_issues_done_time(project_id, task_types = nil)
    db = connect_db()
    project_id = Integer(project_id)

    if task_types
      task_types_str = task_types.join(',')

      if task_types.size == 0
        task_types_str = "-1"
      end

      #puts task_types_str + "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"

      str_other_tasks = ""
      if task_types.include?(-1)
        str_other_tasks = " or custom_values.value is NULL"
      end

      result = db.select_one("SELECT sum(estimated_hours*done_ratio/100.0) FROM issues
                                left JOIN custom_values ON issues.id=custom_values.customized_id and custom_values.custom_field_id = #{Task_id_custom_field_id}
                                WHERE project_id = #{project_id} and (custom_values.value in (#{task_types_str}) #{str_other_tasks})")
      #puts "1a................................................."

    else
      result = db.select_one("select sum(estimated_hours*done_ratio/100.0) from issues where project_id=#{project_id}")
      #puts "1b................................................."
    end

    #puts "2................................................."
    #puts result.to_a[0][1]
    if result.to_a[0][1] == nil
      return 0
    end
    return Float(result.to_a[0][1])
  end

  def get_unassigned_tasks_for_project(rm_project_identifier, task_types = nil)

    db = connect_db()

    str_other_tasks = ""
    task_types_str = "-1"

    if task_types && task_types.size > 0
      task_types_str = task_types.join(',')
      if task_types.include?(-1)
        str_other_tasks = " or cv2.value is NULL or cv2.value = '' "
      end
    end

    if task_types != nil
      task_types_condition = " and (cv2.value in (#{task_types_str}) #{str_other_tasks})"
    else
      task_types_condition = ""
    end

    all_issues = db.select_all("SELECT i.*, cv1.value as page_id, cv2.value as task_id FROM issues as i
        LEFT JOIN custom_values as cv1 ON i.id=cv1.customized_id and cv1.custom_field_id = #{Page_id_custom_field_id}
        LEFT JOIN custom_values as cv2 ON i.id=cv2.customized_id and cv2.custom_field_id = #{Task_id_custom_field_id}
            where i.project_id=(select id from projects where identifier = '#{rm_project_identifier}' limit 1) and (cv1.value = '' or cv1.value is null)")

    filtered_issues = db.select_all("SELECT i.*, cv1.value as page_id, cv2.value as task_id FROM issues as i
        LEFT JOIN custom_values as cv1 ON i.id=cv1.customized_id and cv1.custom_field_id = #{Page_id_custom_field_id}
        LEFT JOIN custom_values as cv2 ON i.id=cv2.customized_id and cv2.custom_field_id = #{Task_id_custom_field_id}
            where i.project_id=(select id from projects where identifier = '#{rm_project_identifier}' limit 1) and (cv1.value = '' or cv1.value is null) #{task_types_condition}")

    return all_issues, filtered_issues
  end

end


