class Search

  def title(str)
    conn = ActiveRecord::Base.connection
    terms = str.split(" ")
    query = ActiveRecord::Base.send(:sanitize_sql_array, ["SELECT * FROM watchables WHERE title_tsvector @@ to_tsquery('english', ?)", str])
    # query = conn.execute(query)
  end
end
