require 'test_helper'

class AzProjectStatUpdatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:az_project_stat_updates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create az_project_stat_update" do
    assert_difference('AzProjectStatUpdate.count') do
      post :create, :az_project_stat_update => { }
    end

    assert_redirected_to az_project_stat_update_path(assigns(:az_project_stat_update))
  end

  test "should show az_project_stat_update" do
    get :show, :id => az_project_stat_updates(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => az_project_stat_updates(:one).to_param
    assert_response :success
  end

  test "should update az_project_stat_update" do
    put :update, :id => az_project_stat_updates(:one).to_param, :az_project_stat_update => { }
    assert_redirected_to az_project_stat_update_path(assigns(:az_project_stat_update))
  end

  test "should destroy az_project_stat_update" do
    assert_difference('AzProjectStatUpdate.count', -1) do
      delete :destroy, :id => az_project_stat_updates(:one).to_param
    end

    assert_redirected_to az_project_stat_updates_path
  end
end
