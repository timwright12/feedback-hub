# frozen_string_literal: true

module Reddit
  class Post
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :author_name, :string
    attribute :updated_at, :datetime
    attribute :title, :string
    attribute :subreddit, :string
    attribute :content, :string
    attribute :link, :string
    attribute :upvote_ratio, :integer

    def self.create_from_object(post)
      new(author_name: post.author.name,
          updated_at: post.created_at,
          title: post.title,
          subreddit: post.subreddit_name_prefixed,
          content: post.selftext,
          link: "https://reddit.com#{post.permalink}",
          upvote_ratio: post.upvote_ratio)
    end

    def posted_date
      updated_at
    end
  end
end
