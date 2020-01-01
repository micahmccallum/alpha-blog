require 'test_helper'

class CreateNewArticle < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(username: "Joseph", email: "joseph@example.com", password: "password")
  end
  test "create new article" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_difference "Article.count", 1 do
      post articles_path, params: { article: { title: "This is new title",
                                            description: "How do you like my description?" }}
    follow_redirect!
    end
    article = Article.last
    assert_response :success
    assert_template 'articles/show'
    assert_select "h2", "Title:  #{article.title}"
  end
end  