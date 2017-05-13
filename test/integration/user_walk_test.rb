require 'test_helper'
require 'test_helper_watir'

class UserWalkTest < ActionController::IntegrationTest
  #fixtures :all

  # Replace this with your real tests.

  Correct_login = 'stg34'
  Correct_password = 'gogamagoga'

  Incorrect_login = 'stg34'
  Incorrect_password = 'gogamagoga1'

  def initialize(z)
    super(z)
    @wt = W_test.new
  end

  test "login" do
    assert @wt.view_news
    assert !@wt.login(Incorrect_login, Incorrect_password)
    assert @wt.view_recover_password
    assert @wt.login(Correct_login, Correct_password)
  end
end
