class AzCollectionTemplate < OwnedActiveRecord

  validates_length_of   :name, :within => 1..32

  def make_copy
    return self
  end
end
