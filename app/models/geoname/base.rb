module Geoname
  class Base < ActiveRecord::Base
    set_table_name "geoname"
    set_primary_key "geonameid"
    def self.approx_find_by_query_and_cp(query, cp)
      nom = I18n.transliterate(query).strip
      Geoname::Base.where("asciiname ilike ? and admin2_code = ? and feature_class = ?", "%#{nom}%", cp, "P")
    end
    def self.find_by_query_and_cp(query, cp)
      nom = I18n.transliterate(query).strip
      Geoname::Base.where("asciiname ilike ? and admin2_code = ? and feature_class = ?", "#{nom}", cp, "P")
    end
  end
end