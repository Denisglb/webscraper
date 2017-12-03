require 'open-uri'
require 'nokogiri'
require 'csv'
require 'HTTParty'

class Scraper
attr_accessor :page, :page_number, :last_number

	def initialize 
		@page_number = []
		url = HTTParty.get("http://www.wegottickets.com/searchresults/all")
		@page ||= Nokogiri::HTML(url)
		@artist = []
		@price = []
		@city=[]
		@venue=[]
		@date=[]
		@description = []
		@time = []
	end

	def page_numbers
		@page.css('.block-group.advance-filled.section-margins.padded.text-center a').each do |line|
		@page_number << line.text.strip
		end
		last_number = @page_number[-2]
		puts last_number
	end
	
	def artist	
		page.css('div.content.block-group.chatterbox-margin h2').each do |line|
		@artist << line.text.strip
		end
	end

	def description	
		page.search('div.venue-details i').remove
		city = page.css('div.venue-details').each do |line|
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
		city_index = @description[i].index(':')
		@city << @description[i].to_s[0...city_index]
		end
	end

	def venue
		description
		@city.length.times do |i| 
		city_index = @description[i].index(':')
		venue_index = @description[i].gsub(/\n/, '^').index('^')
		@venue << @description[i].to_s[city_index+2...venue_index]
		end
	end

	def price
		page.css('div.searchResultsPrice strong').each do |line|
			@price << line.text.strip
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
	
	# Store Data in CSV
	def store
		categories
		CSV.open("event.csv", "w") do |file|
		file << ["Artist", "Price", "City", "Venue", "Date"]

		@artist.length.times do |i|
		file << [@artist[i], @price[i], @city[i], @venue[i], @date[i], @time[i]]
		end
		end
	end
end

scraper = Scraper.new
# scraper.page_numbers
# scraper.artist
scraper.store

