class CreateAzBaseProjectStats < ActiveRecord::Migration
  def self.up
    create_table :az_base_project_stats do |t|
      t.integer :az_base_project_id
      t.integer :components_num

      t.integer :pages_num
      t.integer :pages_words_num

      t.integer :commons_num
      t.integer :commons_words_num

      t.integer :definitions_num
      t.integer :definitions_words_num

      t.integer :structs_num
      t.integer :structs_variables_num

      t.integer :design_sources_num
      t.integer :designs_num
      t.integer :images_num
      t.integer :words_num
      t.integer :disk_usage
      t.float :quality
      t.integer :version

      t.timestamps
    end
    add_index :az_base_project_stats, :az_base_project_id
    add_index :az_base_project_stats, :components_num

    add_index :az_base_project_stats, :pages_num
    add_index :az_base_project_stats, :commons_num
    add_index :az_base_project_stats, :definitions_num
    add_index :az_base_project_stats, :structs_num
    add_index :az_base_project_stats, :structs_variables_num

    add_index :az_base_project_stats, :design_sources_num
    add_index :az_base_project_stats, :designs_num
    add_index :az_base_project_stats, :images_num
    add_index :az_base_project_stats, :words_num

    add_index :az_base_project_stats, :disk_usage
    add_index :az_base_project_stats, :quality

  end

  def self.down
    drop_table :az_base_project_stats
  end
end
