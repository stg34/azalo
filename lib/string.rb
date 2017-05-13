#http://kresimirbojcic.com/2010/06/location-sensitive-downcase-in-ruby-unicode-gem/
class String
  def downcase
    Unicode::downcase(self)
  end

  def capitalize
    Unicode::capitalize(self)
  end
end