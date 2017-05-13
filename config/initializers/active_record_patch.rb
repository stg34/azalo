
module ActiveRecord
  class Base
    def az_clone
      dup = self.class.new
      self.attributes.each_pair{|attr, val| dup.send(attr+'=', val)}
      dup.id = nil
      dup
    end
    def dump_fixture
      fixture_file = "#{Rails.root}/spec/fixtures/#{self.class.table_name}.yml"
      File.open(fixture_file, "a+") do |f|
        f.puts({ "#{self.class.table_name.singularize}_#{id}" => attributes }.
                 to_yaml.sub!(/---\s?/, "\n"))
      end
    end
  end
end
