require 'test_helper'

class DeleteSoftlyTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  setup do
    puts "New setup"
    Post.with_deleted.delete_all
    Comment.with_deleted.delete_all
    Tag.delete_all
    @post1 = Post.create(:title => "post1")
    @post1_id = @post1.id
    @comment1_1 = @post1.comments.create(:email => "test@gmail.com", :body => "Comment 1 for post 1")
    @comment2_1 = @post1.comments.create(:email => "test@gmail.com", :body => "Comment 2 for post 1")
    @comment3_1 = @post1.comments.create(:email => "testother@gmail.com", :body => "Comment 2 for post 1")

    @post2 = Post.create(:title => "post2")
    @post2_id = @post2.id

  end
  test "two records available" do
    assert_equal 2, Post.count
  end
  
  test "destroy count test" do
    @post1.destroy
    assert_equal 1, Post.count
    puts "It is 1"
    assert_equal 2, Post.with_deleted.count 
    puts "It is 2"
    assert_nil Post.find_by_id(@post1_id)
    @post1 = Post.with_deleted.find(@post1_id)
    assert @post1.deleted_at
    @post1.revive
    assert_equal 2, Post.count
  end

  test "deleted, without_deleted methods" do
    assert_equal [@post1, @post2], Post.all.sort_by{|p| p.title}
    @post1.destroy
    assert_equal [@post2], Post.without_deleted
    assert_equal [@post1], Post.deleted
  end

  test "at_time methods" do
    t = Time.now
    @post1.destroy
    assert_equal [@post2], Post.without_deleted
    assert_equal [@post1, @post2], Post.at_time(t)
  end
  
  test "other default scopes" do
    assert_equal 2, Comment.count
    @comment2_1.destroy
    assert_equal 1, Comment.count
  end
end
