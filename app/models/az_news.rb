class AzNews < ActiveRecord::Base
  validates_presence_of :az_user_id
  validates_presence_of :title
  validates_presence_of :announce
  validates_presence_of :body
  validates_presence_of :az_user_id

  belongs_to :az_user

  def self.get_latest_news
    return AzNews.find(:all, :limit => 2, :order =>"created_at DESC", :conditions => {:visible => true})
  end

  def self.get_latest_news_year_month
    news = AzNews.find(:first, :limit => 1, :order =>"created_at DESC", :conditions => {:visible => true})
    return [news.created_at.year, news.created_at.month]
  end

end
