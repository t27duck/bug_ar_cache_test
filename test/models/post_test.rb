require "test_helper"

class PostTest < ActiveSupport::TestCase
  
  test "with ar insert" do
    assert_difference "Post.count" do
      Post.create(title: "post")
    end
  end
  
  test "with raw insert" do
    assert_difference "Post.count" do
      Post.connection.execute("INSERT INTO posts (title, created_at, updated_at) VALUES ('a post', date(), date())")
    end
  end

  test "with raw insert but no cache" do
    Post.uncached do
      assert_difference "Post.count" do
        Post.connection.execute("INSERT INTO posts (title, created_at, updated_at) VALUES ('a post', date(), date())")
      end
    end
  end
end
