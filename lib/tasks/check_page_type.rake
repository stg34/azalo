namespace :content  do
  desc "check page type"

  task :check_page_type => :environment do

    Authorization.current_user = AzUser.find_by_login('admin')

    puts "==================================================================================================="
    puts "==================================================================================================="
    puts "==================================================================================================="

    errors_count = 0
    ok_count = 0

    pages = AzPage.find(:all)
    puts "pages.size = #{pages.size}"

    pages.each do |page|
      
      if page.page_type == page.get_page_type(true)
        #puts "Ok"
        ok_count += 1
      else
        prj = page.get_project_over_block
        puts "#{page.id} #{page.name} #{prj.name} (#{prj.id}) #{prj.owner.ceo.login} ERROR"
        page.page_type = page.get_page_type(true)
        page.save!
        #puts "ERROR"
        errors_count += 1
      end
    end
    puts "errors: #{errors_count}  oks: #{ok_count}"
    puts "==================================================================================================="
    puts "==================================================================================================="
    puts "==================================================================================================="
  end
end
