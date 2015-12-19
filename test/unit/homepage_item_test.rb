require "test_helper"

class HomepageItemTest < ActiveSupport::TestCase
  context "uniquence_of_true_view_more_option_in_category" do
    should "valid" do
      item = FactoryGirl.build(:homepage_item, view_more: true, sequence: 1)

      assert item.valid?
    end

    should "invalid" do
      FactoryGirl.create(:homepage_item, view_more: true, sequence: 1)
      item = FactoryGirl.build(:homepage_item, view_more: true, sequence: 1)

      assert item.invalid?

      assert_equal I18n.t("notices.view_more_already_exists_in_%{category}", category: item.category), item.errors[:view_more].first
    end

    should "not affect non view more item" do
      FactoryGirl.create(:homepage_item, view_more: true, sequence: 1)
      item = FactoryGirl.build(:homepage_item, sequence: 1)

      assert item.valid?
    end
  end
end
