require 'test_helper'

class UpdateCategoryTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(username: "Joseph", email: "joseph@example.com", password: "password", is_admin: true)
    
  end
  
  test "update category" do
    sign_in_as(@user, "password")
    get new_category_path
    assert_template 'categories/new'
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: { name: "sports"}}
      follow_redirect!
    end
    assert_template 'categories/show'
    assert_match "sports", response.body
    @category = Category.last
    get edit_category_path(@category)
    patch category_path(@category), params: { category: { name: "Snow" }}
    follow_redirect!
    # assert_select "div.alert-success"
    @category2 = Category.last
    assert_template 'categories/show'
    assert_match "Snow", response.body
  end
  
  test "invalid category submission results in failure" do
    sign_in_as(@user, "password")
    get new_category_path
    assert_template 'categories/new'
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: { name: ""}}      
    end
    assert_template 'categories/new'
    assert_select 'div.alert-danger' 
  end
end

