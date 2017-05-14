ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  
  def create_statuses()
    ActiveRecord::Base.connection.execute("INSERT INTO `az_project_statuses` (`id`, `name`, `position`, `owner_id`, `created_at`, `updated_at`, `state`, `description`) VALUES
            (1, 'Новый', 1, 1, '2010-12-22 10:09:20', '2010-12-22 10:09:20', 0, ''),
            (2, 'Обсуждается', 2, 1, '2010-12-22 10:09:20', '2011-09-25 10:34:32', 0, ''),
            (3, 'В процессе', 3, 1, '2010-12-22 10:09:20', '2011-09-25 10:34:24', 0, ''),
            (4, 'Тестирование', 4, 1, '2010-12-22 10:09:20', '2011-09-25 10:34:16', 0, ''),
            (5, 'Сдача', 5, 1, '2010-12-22 10:09:20', '2011-09-25 10:34:08', 0, ''),
            (6, 'Сделан', 6, 1, '2010-12-22 10:09:20', '2011-09-25 10:33:58', 0, ''),
            (7, 'Закрыт', 7, 1, '2011-09-25 10:33:35', '2011-09-25 10:33:35', 1, ''),
            (8, 'Заморожен', 8, 1, '2011-09-25 10:33:48', '2011-09-25 10:33:48', 1, '')")
  end

end
