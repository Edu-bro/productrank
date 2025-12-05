require "test_helper"

class ChallengesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get challenges_index_url
    assert_response :success
  end

  test "should get weekly" do
    get challenges_weekly_url
    assert_response :success
  end

  test "should get monthly" do
    get challenges_monthly_url
    assert_response :success
  end
end
