class Response < ActiveRecord::Base

  validates :user_id, :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :respondent_is_not_the_poll_author

  def respondent_has_not_already_answered_question
    query = "
      SELECT r.*
      FROM questions q
      JOIN answer_choices ac
      ON q.id = ac.question_id
      JOIN responses r
      ON ac.id = r.answer_choice_id
      WHERE r.user_id = ?
      AND q.id = ?
    "
    response = Response.find_by_sql([query, self.user_id, q_id])

    errors[:base] << "Cannot answer same question twice." if !response.empty? && self.id.nil?
  end

  def respondent_is_not_the_poll_author
    errors[:base] << "Cannot answer your own poll." if self.user_id == poll_author_id
  end

  belongs_to(
    :respondent,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )

  belongs_to(
    :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  private

    def q_id
      self.answer_choice.question_id
    end

    def poll_author_id
      poll_authors = #should only be one
      User.select("users.*").joins(authored_polls: [questions: :answer_choices]).where("answer_choices.id = ?", 2)

      poll_authors[0].id # works!
    end

end
