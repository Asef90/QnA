module SearchHelper
  def match_template(match)
    "search/#{match.class.name.downcase}"
  end

  def commentable_path(commentable)
    commentable.is_a?(Question) ? question_path(commentable) : question_path(commentable.question)
  end
end
