First Webscrape!


Built in Ruby, scrapping the Wegottickets website

The scrapper searches for Artist, Price, City, Venue, Date and Time so you can have them all in a CSV file and easily view on Excel! 


*Instructions*
- Run bundle install

- Clear CSV file

- *Caution* The programme will scrape all the data from all the pages. If you would like to scrape the first 10 results then change the line in the method scrape_all from @last_number.to_i.times do |i| to 10.times do |i|

- run ruby webscraper.rb
- open CSV file to see the scrapped data

*Challenges*

- When there was a missing price value the table moved. Difficulty scraping non-existant css class.


*Improvements if more time was allowed*

- Testing *will be added shortly
- Further refactoring

*Time compelted*
 ~ 8 hours
 (6 hours more than the allowed 2 hours)

*New Technologies learnt*

- open-uri
- nokogiri
-