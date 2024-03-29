class Question < ApplicationRecord
  validates_presence_of :answer, :body

  belongs_to :author, class_name: 'User'
  has_one :answer, dependent: :destroy

  has_many :question_references, dependent: :destroy
  has_many :references, through: :question_references

  has_many :question_viewers, foreign_key: :viewed_question_id, dependent: :destroy
  has_many :viewers, through: :question_viewers, class_name: 'User'

  has_many :upvotes, dependent: :destroy
  has_many :downvotes, dependent: :destroy

  after_create :initial_upvote

  accepts_nested_attributes_for :answer

  def references_by_rule_order
    references.all.sort_by(&:created_at)
  end

  def net_votes
    upvotes.count - downvotes.count
  end

  def self.top_upvoted_from_last_week(limit = 3)
    where('created_at > ?', 1.week.ago)
      .sort_by(&:net_votes)
      .reverse
      .take(limit)
  end

  private

  def initial_upvote
    upvotes.create(user_id: self.author_id)
  end
end
