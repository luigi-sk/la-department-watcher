require 'test_helper'

module LaDepartmentWatcher
  class DepartmentControllerTest < ActionController::TestCase
    test "should get watch" do
      get :watch
      assert_response :success
    end
  
  end
end
