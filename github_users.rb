require 'net/http'
require 'json'
require 'csv'

require 'byebug'

# example query
# https://api.github.com/search/users?q=tom+repos:%3E42+followers:%3E1000
# https://api.github.com/search/users?q=location%3Anew+york


# GET Request - GitHub API
begin
  url = 'https://api.github.com/search/users?q=location%3Anew+york'
  uri = URI(url)
  resp = Net::HTTP.get(uri)
  data = JSON.parse(resp)['items']
  top_10_users = data[0...10]
rescue
   print "Connection error."
end


# CSV file creation
CSV.open("top_10_github_NY.csv", "wb") do |csv|
  csv << ["login", "name", "location", "repo count"]

  top_10_users.each do |user|
    csv << [user['login'], user['id'], user['gravatar_id'], user['url']]
  end
end
