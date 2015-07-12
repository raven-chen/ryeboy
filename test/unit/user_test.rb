require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "new user should be 'newbie', grade[0] and have no sno" do
    user = FactoryGirl.build(:new_user)

    assert user.save
    assert_equal "newbie", user.roles.first
    assert_equal User::GRADES[0], user.grade
    assert_nil user.sno
  end
end
