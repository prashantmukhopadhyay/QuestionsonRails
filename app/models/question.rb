class Question < ActiveRecord::Base
  validates :text, presence: true

  belongs_to(
    :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id
  )

  has_many(
    :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id
  )

  def results
    results_with_counts = self
         .answer_choices
         .select("answer_choices.*, COUNT(*) AS response_count")
         .group("answer_choices.id")

    results_hash = {}
    results_with_counts.each do |result|
      results_hash[result.answer_text] = result.response_count.to_i
    end

    results_hash
  end

# User.select("users.*").
# joins(authored_polls: [questions: :answer_choices]).
# where("answer_choices.id = ?", 2)


end