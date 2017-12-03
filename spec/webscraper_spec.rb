require_relative '../lib/webscraper'

describe Webscraper do
  doc = HTTParty.get("http://www.wegottickets.com/searchresults/page/#{i+1}/all#paginate")
			@page = Nokogiri::HTML(doc)


end