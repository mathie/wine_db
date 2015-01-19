module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    def search(query)
      query_function = sanitize_sql_array(["plainto_tsquery('english', ?)", query])
      conditions = "search_vector @@ #{query_function}"
      order = "ts_rank_cd(search_vector, #{query_function}) DESC"

      where(conditions).order(order)
    end
  end
end