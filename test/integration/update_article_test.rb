require 'test_helper'

class UpdateArticleTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(username: "Joseph", email: "joseph@example.com", password: "password", is_admin: false)
  end
  test "user can update article" do  
    sign_in_as(@user, "password")
    get new_article_path
    assert_difference "Article.count", 1 do
      post articles_path, params: { article: { title: "This is new title",
                                              description: "How do you like my description?" }}
    follow_redirect!
    end
    
    get edit_article_path(Article.last)
    patch article_path(Article.last), params: { article: { title: "This is new title edited",
                                description: "How do you like my description? I know you do." }}
    
    follow_redirect!
    assert_select "div.alert-success"
    @article = Article.last
    assert_template 'articles/show'
    assert_select "h2", "Title:  #{@article.title}"
   
  end                                 
end  