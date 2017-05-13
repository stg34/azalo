module Statuses
  Statuses = [{ :id => 0, :name => 'В работе',           :color => 'blue',   :image => '/images/tr-status-progress.png'},
              { :id => 1, :name => 'Ждем подтверждения', :color => 'silver', :image => '/images/tr-status-waiting.png'},
              { :id => 2, :name => 'Принято',            :color => 'white',  :image => '/images/tr-status-done.png'}]

  def statuses_for_select
    return Statuses.collect{|s| [s[:name], s[:id]] }
  end
end
