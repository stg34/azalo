class AzBaseProjectStat < ActiveRecord::Base

  belongs_to :az_base_project

  def quality_metric(pages_num_log, value, n, weight)
    x = value/pages_num_log
    return x/Math.sqrt(x*x + n)*weight
  end

  def get_quality


    stat_params = { 
      :components_num =>                        {:n => 0.25,        :weight => 1.5},
      :definitions_num =>                       {:n => 0.25,        :weight => 1.2},
      :commons_common_num =>                    {:n => 0.25,        :weight => 1.0},
      :commons_purpose_functional_num =>        {:n => 0.015625,    :weight => 1.0},
      :commons_purpose_exploitation_num =>      {:n => 0.015625,    :weight => 1.0},
      :commons_acceptance_condition_num =>      {:n => 0.015625,    :weight => 1.0},
      :commons_functionality_num =>             {:n => 0.5625,      :weight => 1.1},
      :commons_content_creation_num =>          {:n => 0.015625,    :weight => 1.0},
      :commons_requirements_hosting_num =>      {:n => 0.015625,    :weight => 1.0},
      :commons_requirements_reliability_num =>  {:n => 0.015625,    :weight => 1.0},
      :pages_words_num =>                       {:n => 16.0,        :weight => 2.0},
      :structs_num =>                           {:n => 1.0,         :weight => 2.0},
      :design_sources_num =>                    {:n => 1.0,         :weight => 1.5},
      :images_num =>                            {:n => 4.0,         :weight => 2.0},

      #:commons_words_num =>                     {:n => 0.015625,    :weight => 1.0},
      #:definitions_words_num =>                 {:n => 0.015625,    :weight => 1.0},
      #version
      #commons_num
      #structs_variables_num
      #designs_num
      #words_num
      #disk_usage
      #quality
      #pages_num
    }
    if pages_num < 3
      return 0
    end

    pages_num_log = Math.log(pages_num)/Math.log(2)

    quality = 0
    stat_params.each_pair do |param, param_attrs|
      qm = quality_metric(pages_num_log, self[param], param_attrs[:n], param_attrs[:weight])
      #puts "#{param} -> #{qm}"
      quality += qm
    end

    return quality
  end
end

