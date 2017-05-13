class AddMetricsToProjectStat < ActiveRecord::Migration
  def self.up
    add_column :az_base_project_stats, :commons_common_num, :integer
    add_column :az_base_project_stats, :commons_acceptance_condition_num, :integer
    add_column :az_base_project_stats, :commons_content_creation_num, :integer
    add_column :az_base_project_stats, :commons_purpose_exploitation_num, :integer
    add_column :az_base_project_stats, :commons_purpose_functional_num, :integer
    add_column :az_base_project_stats, :commons_requirements_hosting_num, :integer
    add_column :az_base_project_stats, :commons_requirements_reliability_num, :integer
    add_column :az_base_project_stats, :commons_functionality_num, :integer
  end

  def self.down
    remove_column :az_base_project_stats, :commons_common_num
    remove_column :az_base_project_stats, :commons_acceptance_condition_num
    remove_column :az_base_project_stats, :commons_content_creation_num
    remove_column :az_base_project_stats, :commons_purpose_exploitation_num
    remove_column :az_base_project_stats, :commons_purpose_functional_num
    remove_column :az_base_project_stats, :commons_requirements_hosting_num
    remove_column :az_base_project_stats, :commons_requirements_reliability_num
    remove_column :az_base_project_stats, :commons_functionality_num
  end
end

