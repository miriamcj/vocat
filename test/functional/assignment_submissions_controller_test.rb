require 'test_helper'

class AssignmentSubmissionsControllerTest < ActionController::TestCase
  setup do
    @assignment_submission = assignment_submissions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assignment_submissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create assignment_submission" do
    assert_difference('AssignmentSubmission.count') do
      post :create, assignment_submission: { name: @assignment_submission.name, summary: @assignment_submission.summary }
    end

    assert_redirected_to assignment_submission_path(assigns(:assignment_submission))
  end

  test "should show assignment_submission" do
    get :show, id: @assignment_submission
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @assignment_submission
    assert_response :success
  end

  test "should update assignment_submission" do
    put :update, id: @assignment_submission, assignment_submission: { name: @assignment_submission.name, summary: @assignment_submission.summary }
    assert_redirected_to assignment_submission_path(assigns(:assignment_submission))
  end

  test "should destroy assignment_submission" do
    assert_difference('AssignmentSubmission.count', -1) do
      delete :destroy, id: @assignment_submission
    end

    assert_redirected_to assignment_submissions_path
  end
end
