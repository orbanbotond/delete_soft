require "delete_soft/version"

require 'active_record'
require 'squeel'
require 'class_methods'
require 'instance_methods'

module DeleteSoftly
  module ARExtender

    # Always have Model.active available. It is a good practice to use it
    # when you want the active records. Even use it when no logic is in 
    # place yet. Now it is an alias for scoped, but can be overwritten
    # for custom behaviour, for example:
    #  class Post < ActiveRecord::Base
    #    delete_softly
    #    has_many :comments
    #    def self.active
    #       super.where(:disabled.ne => true)
    #    end
    #  end
    #  class Comment < ActiveRecord::Base
    #    belongs_to :post
    #  end
    # will result in:
    #  Post.all #=> SELECT * FROM posts WHERE deleted_at IS NULL;
    #  Post.active #=> SELECT * FROM posts WHERE deleted_at IS NULL AND disabled != 't';
    #  Comment.all #=> SELECT * FROM comments;
    #  Comment.active #=> SELECT * FROM comments;
    def active
      scoped
    end 

    # Make the model delete softly. A deleted_at:datetime column is required
    # for this to work.
    # The two most important differences are that it can be enforce on a model
    # or be more free. 
    #  class Post < ActiveRecord::Base
    #    delete_softly
    #  end
    # will enforce soft delete on the post model. A deleted post will never appear,
    # unless the explicit with_deleted is called. When the model is:
    #  class Post < ActiveRecord::Base
    #    delete_softly :enforce => false
    #  end
    # An object will still be available after destroy is called, 
    def delete_softly(options = {:enforce => :active})
      # Make destroy! the old destroy
      alias_method :destroy!, :destroy

      include DeleteSoftly::InstanceMethods
      extend DeleteSoftly::ClassMethods
      # Support single argument
      #  delete_softly :active # Same as :enforce => :active, default behaviour
      #  delete_softly :enforce=> :with_deleted # Same as without argument
      options = {:enforce=> options } unless options.is_a?(Hash)
      if options[:enforce]
        if options[:enforce].is_a?(Symbol) && respond_to?(options[:enforce])
          default_scope send(options[:enforce])
        else
          default_scope active
        end
      end
    end
  end
end

ActiveRecord::Base.send(:extend, DeleteSoftly::ARExtender)
