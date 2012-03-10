require 'csv'
require 'zip/zip'
desc "Fetch and update geonames data. You cann pass a tld to scope fetched data"

namespace :geopod do
	task :update, [:tld, :single_inserts] => :environment do |t, a|
    a.with_defaults(:tld => "allCountries", :single_inserts => false)
    TLD = a.tld
    SINGLE_INSERTS = a.single_inserts

	  SERVER = "http://download.geonames.org"
	  DUMP_PATH = "/export/dump/"

	  FILE_NAME= "#{TLD.upcase}.zip"

    URL = "#{SERVER}#{DUMP_PATH}#{FILE_NAME}"

    %x[curl -o /tmp/geodump.zip #{URL}]

    inserts = []
    fields = []

    if TLD
      DUMP_FILE= "#{TLD.upcase}.txt"
    else
      DUMP_FILE= "allCountries.txt"
    end

    Zip::ZipFile.open("/tmp/geodump.zip") do |zipfile|
      CSV.parse(zipfile.read(DUMP_FILE), {:col_sep => "\t", :quote_char =>"\0"}) do |row|
        fields = []
        fields  <<  row[0].to_i  # geonameid
        fields  <<  row[1]       # name
        fields  <<  row[2]       # asciiname
        fields  <<  row[3]       # alternatenames
        fields  <<  row[4].to_f  # latitude
        fields  <<  row[5].to_f  # longitude
        fields  <<  row[6]       # feature_class
        fields  <<  row[7]       # feature_code
        fields  <<  row[8]       # country_code
        fields  <<  row[9]       # cc2
        fields  << row[10]       # admin1_code
        fields  << row[11]       # admin2_code
        fields  << row[12]       # admin3_code
        fields  << row[13]       # admin4_code
        fields  << row[14].to_i  # population
        fields  << row[15].to_i  # elevation
        fields  << row[16].to_i  # dem
        fields  << row[17]       # timezone
        fields  << row[18]       # modification_date
        fields  << Time.now
        fields  << Time.now
        inserts << "(#{fields.map{|f| ActiveRecord::Base.connection.quote(f) }.join(",")})"
      end
    end

    FIELDS = (%w{ geonameid name asciiname alternatenames
                 latitude longitude feature_class feature_code
                 country_code cc2 admin1_code admin2_code admin3_code
                 admin4_code population elevation dem timezone modification_date} + [:updated_at, :created_at]).join(', ')

    nil.tap do
      ActiveRecord::Base.transaction do
        ActiveRecord::Base.connection.execute("delete from geoname")
        if SINGLE_INSERTS 
          inserts.each do |insert|
            ActiveRecord::Base.connection.execute("INSERT INTO geoname (#{FIELDS}) VALUES #{insert};")
          end
        else
          ActiveRecord::Base.connection.execute("INSERT INTO geoname (#{FIELDS}) VALUES #{inserts.join(',')} ;")
        end
      end
    end




	end
end
