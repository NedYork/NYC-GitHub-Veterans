require 'net/http'
require 'csv'



CSV.open("top_10_github_NY.csv", "wb") do |csv|
  csv << ["login", "name", "location", "repo count"]
  csv << ["user1", "test name", "NY", 5]
end
