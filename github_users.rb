require 'net/http'
require 'json'
require 'csv'

require 'byebug'

begin
  url = 'https://api.github.com/users?since=0/'
  uri = URI(url)
  resp = Net::HTTP.get(uri)
  data = JSON.parse(resp)
  byebug

rescue
   print "Connection error."
end


CSV.open("top_10_github_NY.csv", "wb") do |csv|
  csv << ["login", "name", "location", "repo count"]
  csv << ["user1", "test name", "NY", 5]
end
