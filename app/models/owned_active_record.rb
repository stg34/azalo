class OwnedActiveRecord < ActiveRecord::Base

#  def self.get_current_user(usr)
#    return Authorization.current_user
#  end

  self.abstract_class = true

  belongs_to :owner, :foreign_key => 'owner_id', :class_name => 'AzCompany'

  def validate
    validate_owner_id_in_my_works
  end

  def validate_owner_id_common(name, parent_name)
    if az_base_project != nil && az_base_project.owner_id != owner_id
      errors.add_to_base("Incorrect owner_id value. #{parent_name} project has '#{az_base_project.owner_id}', #{name} has '#{owner_id}'")
    end
  end

  def get_label_for_activity
    return self.name
  end

#  def self.find1(*args)
#    puts args.inspect
#    company_ids = Authorization.current_user.my_works.collect{|c| c.id}
#    args << {:conditions => {:owner_id => company_ids}}
#    return find(*args)
#  end

  def self.get_by_companies(companies)
    items = {}
    companies.each do |company|
      items[company] = get_by_company(company)
    end
    return items
  end

  def get_owner_name
    if owner != nil
      return owner.name
    end
  end

  def get_my_works
    return Authorization.current_user.my_works
  end

  def get_all_works
    return AzCompany.all
  end

  def validate_owner_id_in_my_works
    if Authorization.current_user.roles.include?(:admin)
      works = get_all_works.collect{ |w| w.id }
    else
      works = get_my_works.collect{ |w| w.id }
    end

    if !works.include?(owner_id)
      errors.add_to_base("Incorrect owner_id value. No my work with id '#{owner_id}' #{self.class}")
    end
  end

  
end
