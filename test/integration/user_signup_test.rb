require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  test "on signup new user is logged in to profile page" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: { username: "bob",
                                 email: "bob@example.com",
                                 password: "password" }}
      follow_redirect!
    end
    user = User.last
    assert_equal session[:user_id], user.id
    assert_template 'users/show'
    assert_response :success
    assert_select "h4", text: "#{user.username}'s articles"
  end
end