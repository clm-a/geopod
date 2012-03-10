require "grape"
module Geopod
  class API < Grape::API

    resource "geonames" do
      get do
        Geoname::Base.limit(5).all
      end
      get ':id' do
        Geoname::Base.find_by_geonameid(params[:id])
      end
    end
 
  end
end
