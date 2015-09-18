require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "new user should be 'newbie', grade[0] and have no sno. also have task for newbie" do
    user = FactoryGirl.build(:new_user)
    task = FactoryGirl.create(:task, name: User::NEWBIE_TASK_NAME)

    assert user.save
    assert_equal "newbie", user.roles.first
    assert_equal User::GRADES[0], user.grade
    assert user.my_tasks.include?(task)
    assert_nil user.sno
  end
end
