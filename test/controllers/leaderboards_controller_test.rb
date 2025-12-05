require "test_helper"

class LeaderboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get leaderboards_index_url
    assert_response :success
  end

  test "should get daily" do
    get leaderboards_daily_url
    assert_response :success
  end

  test "should get weekly" do
    get leaderboards_weekly_url
    assert_response :success
  end

  test "should get monthly" do
    get leaderboards_monthly_url
    assert_response :success
  end

  test "should get yearly" do
    get leaderboards_yearly_url
    assert_response :success
  end

  test "should get all_time" do
    get leaderboards_all_time_url
    assert_response :success
  end
end
