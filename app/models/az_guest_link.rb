require 'md5'

class AzGuestLink < OwnedActiveRecord # TODO

  Link_expirations = [['1 день', 1],
                      ['2 дня', 2],
                      ['3 дня', 3],
                      ['1 недею', 7],
                      ['2 недели', 14],
                      ['3 недели', 21],
                      ['1 месяц', 30],
                      ['2 месяца', 60],
                      ['3 месяца', 90]]

  belongs_to :az_project, :foreign_key => :az_base_project_id
  belongs_to :az_user

  validates_presence_of :az_base_project_id

  # TODO validete az_guest_link.owner_id == az_base_project.owner_id

  attr_accessor :expired_in

  def before_validation_on_create
    # TODO проверить, что такого хэша еще нет
    self.hash_str = MD5.new('g8482h9' + Time.now.to_s).hexdigest
  end

  def self.get_project_guest_links(project)
    AzGuestLink.remove_expired_links
    return find(:all, :conditions => ["az_base_project_id = ? and expired_at >= Now()", project.id])
  end

  def self.find_by_hash(hash_str)
    return find(:first, :conditions => ["hash_str = ? and expired_at >= Now()", hash_str])
  end

  def self.remove_expired_links
    conditions = [" expired_at < Now() "]
    links_to_remove = AzGuestLink.find(:all, :conditions => conditions)
    links_to_remove.each do |lnk|
      if lnk.az_user
        lnk.az_user.destroy
      end
      lnk.destroy
    end
  end

end
