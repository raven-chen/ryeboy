module ReportHelper
  def mentor_options mentors
    options_from_collection_for_select(mentors, "id", "username", mentors.map(&:id))
  end
end
