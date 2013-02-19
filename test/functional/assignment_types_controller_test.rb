require 'test_helper'

class AssignmentTypesControllerTest < ActionController::TestCase
  setup do
    @assignment_type = assignment_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assignment_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assignment_type" do
    assert_difference('AssignmentType.count') do
      post :create, assignment_type: { name: @assignment_type.name }
    end

    assert_redirected_to assignment_type_path(assigns(:assignment_type))
  end

  test "should show assignment_type" do
    get :show, id: @assignment_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assignment_type
    assert_response :success
  end

  test "should update assignment_type" do
    put :update, id: @assignment_type, assignment_type: { name: @assignment_type.name }
    assert_redirected_to assignment_type_path(assigns(:assignment_type))
  end

  test "should destroy assignment_type" do
    assert_difference('AssignmentType.count', -1) do
      delete :destroy, id: @assignment_type
    end

    assert_redirected_to assignment_types_path
  end
end
