class QuestionFeatureTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    random_questions(20)
  end

  test "shows questions as viewed after clicking on the answer" do
  end

  test "remains viewed after clicking the answer again" do
  end

  test "remains viewed after logging out and back in" do
  end

  test "shows none viewed for a new user" do
  end
end