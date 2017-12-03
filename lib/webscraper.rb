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
		@name = []
		@price = []
		@description=[]
	end

	def page_numbers
		@page.css('.block-group.advance-filled.section-margins.padded.text-center a').each do |line|
		@page_number << line.text.strip
		end
		last_number = @page_number[-2]
		puts last_number
	end
	
	def name	
		page.css('div.content.block-group.chatterbox-margin').each do |line|
		@name << line.text.strip
		end
		puts @name
	end

	def city	
		page.search('div.venue-details i').remove
		description = page.css('div.venue-details').each do |line|
		@description << line.text.strip
		end
		@description.length.times do |i| 
		p @description[i].to_s[0..-30]
		end
	end

	def price
		page.css('div.searchResultsPrice strong').each do |line|
			@price << line.text.strip
		end
	end

	# Headings for CSV file
	def headings
		CSV.open("event.csv", "w") do |file|
		file << ["Description", "Price", "ticket availability", "Additional Information"]
	end
	end
	# Store Data in CSV
	def store
		description.length.times do |i|
		file << [@description[i], @price[i]]
		end
	end
end

scraper = Scraper.new
scraper.page_numbers
# scraper.name
scraper.city

