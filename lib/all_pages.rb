
class All_pages
	attr_reader :page, :last_number

	def initialize
		url = HTTParty.get("http://www.wegottickets.com/searchresults/all")
		@page ||= Nokogiri::HTML(url)
		@page_number = []
		@last_number = last_number
	end

	def page_numbers
		page.css('.block-group.advance-filled.section-margins.padded.text-center a').each do |line|
		@page_number << line.text.strip
		end
		last_number = @page_number[-2]
	end
end
