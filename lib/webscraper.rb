require_relative './all_pages'
require 'open-uri'
require 'nokogiri'
require 'csv'
require 'HTTParty'

class Scraper
attr_accessor :page, :last_number, :artist

	def initialize 
		@last_number = All_pages.new.page_numbers
		@artist = []
		@price = []
		@city=[]
		@venue=[]
		@date=[]
		@description = []
		@time = []
	end

	def artist	
		@page.css('div.content.block-group.chatterbox-margin h2').each do |line|
		@artist << line.text.strip
		end
	end

	def description	
		@page.search('div.venue-details i').remove
		page.css('div.venue-details').each do |line|
		@description << line.text.strip
		end
	end

	def date
		description
		@description.length.times do |i| 
		@date << @description[i].to_s[-25..-7]
		end
	end

	def time
		description
		@description.length.times do |i| 
		@time << @description[i].to_s[-7..-1]
		end
	end

	def city
		description
		@description.length.times do |i| 
		city_index = @description[i].to_s.index(':')
		@city << @description[i].to_s[0...city_index.to_i]
		end
	end

	def venue
		description
		@city.length.times do |i| 
		city_index = @description[i].to_s.index(':')
		venue_index = @description[i].to_s.gsub(/\n/, '^').index('^')
		@venue << @description[i].to_s[city_index.to_i + 2...venue_index.to_i]
		end
	end

	def price
		result = @page.css('div.content.block-group.chatterbox-margin block.diptych.text-right searchResultsPrice strong')
		if result 
			@page.css('div.searchResultsPrice strong').each do |line|
			@price << line.text.strip
			end
			p result
		else
			@price << "unspecified"
		end
	end

	def categories
		artist
		date
		city
		venue
		price
		time
	end

	def scrape_all
		@last_number.to_i.times do |i|
			doc = HTTParty.get("http://www.wegottickets.com/searchresults/page/#{i+1}/all#paginate")
			@page = Nokogiri::HTML(doc)
			categories
		end
		store
	end

# Store Data in CSV
	def store
		# categories
		CSV.open("event.csv", "w") do |file|
		file << ["Artist", "Price", "City", "Venue", "Date", "Time"]

		@artist.length.times do |i|
		file << [@artist[i], @price[i], @city[i], @venue[i], @date[i], @time[i]]
		end
		end
	end
end


scraper = Scraper.new
p scraper.last_number
scraper.scrape_all

