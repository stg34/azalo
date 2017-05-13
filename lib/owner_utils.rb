module OwnerUtils

#  def get_owner_name
#    if owner != nil
#      return owner.name
#    end
#  end
#
#  def get_my_works
#    puts "get_my_works ------------------------------------------"
#    return Authorization.current_user.my_works
#  end
#
#  def validate_owner_id_in_my_works
#    unless Authorization.current_user.roles.include?(:admin)
#      if !get_my_works.collect{ |w| w.id }.include?(owner_id)
#        errors.add_to_base("Incorrect owner_id value. No my work with id '#{owner_id}'")
#        puts "------------------------------------------"
#        puts self.inspect
#        puts "validate_owner_id_in_my_works Incorrect owner_id value. No my work with id '#{owner_id}'"
#      end
#    end
#  end

end
