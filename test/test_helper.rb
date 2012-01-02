require 'rubygems'
require 'test/unit'
require 'arel'
require 'active_support'
require 'active_support/all'
require 'delete_soft'
require 'sqlite3'


ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'test/db.sqlite3'
)

class Post < ActiveRecord::Base
  delete_softly
  has_many :comments
end

class Comment < ActiveRecord::Base
  delete_softly
  belongs_to :post
  has_many :tags
  default_scope where(:email => 'test@gmail.com')
end

class Tag < ActiveRecord::Base
  belongs_to :comment
end

if Post.table_exists?
  ActiveRecord::Base.connection.drop_table "posts"
end

puts  "Creating  table posts"
ActiveRecord::Base.connection.create_table "posts" do |t|
  t.string :title
  t.text :body
  t.datetime :deleted_at
  t.timestamps
end

if Comment.table_exists?
  ActiveRecord::Base.connection.drop_table "comments"
end

puts  "Creating  table comments"
ActiveRecord::Base.connection.create_table "comments" do |t|
  t.string :email
  t.text :body
  t.integer :post_id
  t.datetime :deleted_at
  t.timestamps
end

if Tag.table_exists?
  ActiveRecord::Base.connection.drop_table "tags"
end

puts  "Creating  table tags"
ActiveRecord::Base.connection.create_table "tags" do |t|
  t.string :name
  t.integer :comment_id
  t.timestamps
end
