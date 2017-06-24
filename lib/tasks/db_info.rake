
namespace :azalo  do
  desc 'db info: records by tables'
  task :db_info => :environment do
    models = ActiveRecord::Base.connection.tables.map{|t| t.classify}
    skip = %w(SchemaMigration AzMailingHeaderFooter AzMailingMessage AzMailingMessagesCategory AzMailing AzOutbox AzProjectDefinition AzRmRole AzTask)
    models.reject!{|m| skip.include?(m)}
    tables_counts = models.inject({}){|h, m| h[m] = m.constantize.count; h}
    tables_by_name = tables_counts.inject([]){|a, r| a << [r.first, r.second]; a}.sort
    tables_by_count = tables_counts.inject([]){|a, r| a << [r.second, r.first]; a}.sort
    longest_table_name = tables_by_name.map{|r| r.first.length}.max
    tables_by_name.each {|e| puts e.first.ljust(longest_table_name + 1) + e.second.to_s }
    puts '-'*80
    tables_by_count.each {|e| puts e.second.ljust(longest_table_name + 1) + e.first.to_s }
    puts '-'*80
    puts 'Total: ' + tables_by_count.map(&:first).sum.to_s
  end
end

