require 'test_helper'

class AzBaseProjectStatsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:az_base_project_stats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create az_base_project_stat" do
    assert_difference('AzBaseProjectStat.count') do
      post :create, :az_base_project_stat => { }
    end

    assert_redirected_to az_base_project_stat_path(assigns(:az_base_project_stat))
  end

  test "should show az_base_project_stat" do
    get :show, :id => az_base_project_stats(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => az_base_project_stats(:one).to_param
    assert_response :success
  end

  test "should update az_base_project_stat" do
    put :update, :id => az_base_project_stats(:one).to_param, :az_base_project_stat => { }
    assert_redirected_to az_base_project_stat_path(assigns(:az_base_project_stat))
  end

  test "should destroy az_base_project_stat" do
    assert_difference('AzBaseProjectStat.count', -1) do
      delete :destroy, :id => az_base_project_stats(:one).to_param
    end

    assert_redirected_to az_base_project_stats_path
  end
end
