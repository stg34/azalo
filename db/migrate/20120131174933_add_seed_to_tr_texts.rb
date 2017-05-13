class AddSeedToTrTexts < ActiveRecord::Migration
  
  def self.up
      add_column 'az_tr_texts', :seed, :boolean, :default => false, :null => false
  end

  def self.down
      remove_column 'az_tr_texts', :seed
  end
end
