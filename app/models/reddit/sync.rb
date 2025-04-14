# frozen_string_literal: true

module Reddit
  class Sync
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveRecord::AttributeAssignment

    attribute :after, :string
    attribute :limit, :integer, default: 100
    attribute :restrict_to, :string, default: 'VeteransBenefits+Veterans'

    def client
      @client ||= Client.new
    end

    def sync_subreddit(subreddit:, start_date: Date.today, end_date: Date.today)
      (start_date.to_datetime..end_date.to_datetime).each do |date|
        if should_sync_date?(date)
          after = Reddit::Submission.where(reddit_created_at: date.end_of_day..).order(reddit_created_at: :desc).first&.reddit_id
          runner = Runner.create(source: :reddit, start_date: date.beginning_of_day, end_date: date.end_of_day)
          runner.end_date = DateTime.now if date == Date.today
          sync_submissions(subreddit:, date:, after:) if should_sync_date?(date)
          runner.update(completed: true)
        end
      end
    end

    private

    def should_sync_date?(date)
      date > Date.today - 3.days || !Runner.synced_date?(date:, source: :reddit)
    end

    def sync_submissions(subreddit:, date: Date.today, after: nil)
      existing_submissions = Reddit::Submission.includes(:comments, :author)
                                               .where(reddit_created_at: date.beginning_of_day..date.end_of_day)
                                               .order(:reddit_created_at)

      results = client.session.subreddit(subreddit).new(limit:, after:)

      listing_submissions = results.to_a
      listing_submissions.each do |listing_submission|
        next if listing_submission.deleted?

        submission = find_or_create_listing(existing_submissions:, listing_submission:, subreddit:)

        if listing_submission.comment_count != submission.comment_count
          sync_comments(submission, listing_submission.comments, subreddit)
        end
      end

      if listing_submissions.last.created_at > date.beginning_of_day
        sync_submissions(subreddit:, date:, after: listing_submissions.last.id)
      end
    end

    def sync_comments(listing, comments, subreddit)
      comments.each do |listing_comment|
        next if listing_comment.deleted?

        comment = find_or_create_comment(listing:, listing_comment:, subreddit:)
        sync_comments(comment, listing_comment.replies, subreddit) if comment.comment_count != listing_comment.replies.count
      end
    end

    def find_or_create_listing(existing_submissions:, listing_submission:, subreddit:)
      submission = existing_submissions.find { |s| s.reddit_id == listing_submission.id }

      submission ||= Reddit::Submission.new(reddit_id: listing_submission.id)

      submission.assign_attributes(
        title: listing_submission.title,
        body: listing_submission.selftext,
        url: listing_submission.url,
        upvotes: listing_submission.ups,
        downvotes: listing_submission.downs,
        reddit_created_at: listing_submission.created_at,
        subreddit:
      )

      submission.author ||= Reddit::Author.find_or_create_by(reddit_id: listing_submission.author.id) do |a|
        a.name = listing_submission.author.name
      end

      submission.save
      submission
    end

    def find_or_create_comment(listing:, listing_comment:, subreddit:)
      comment = listing.comments.find { |c| c.reddit_id == listing_comment.id }
      comment ||= listing.comments.build(reddit_id: listing_comment.id)

      comment.assign_attributes(
        title: listing_comment.title,
        body: listing_comment.body,
        url: listing_comment.link,
        upvotes: listing_comment.ups,
        downvotes: listing_comment.downs,
        reddit_created_at: listing_comment.created_at,
        subreddit:
      )

      comment.author ||= Reddit::Author.find_or_create_by(reddit_id: listing_comment.author.id) do |a|
        a.name = listing_comment.author.name
      end

      comment.save
      comment
    end
  end
end
