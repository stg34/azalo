namespace :azalo  do
  desc "set free tariff to all"
  task :subscribe_all => :environment do

    users = AzUser.find(:all)
    categories = AzSubscribtionCategory.find(:all)

    users.each_with_index do |user, i|
      if user.roles.include?(:user)

        puts "#{i}   subscribe user #{user.login} #{user.id}"

        user.az_subscribtion_categories.clear
        user.az_subscribtion_categories = categories
        user.save
      end
    end
  end
end
