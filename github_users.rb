require 'net/http'
require 'json'
require 'csv'

require 'byebug'


# GET Request For All Users in NY- GitHub API
begin
  # example query
  # https://api.github.com/search/users?q=tom+repos:%3E42+followers:%3E1000
  # https://api.github.com/search/users?q=location%3Anew+york

  url = 'https://api.github.com/search/users?q=location%3Anew+york'
  uri = URI(url)
  resp = Net::HTTP.get(uri)
  data = JSON.parse(resp)['items']

  usernames = [];
  data.each do |user|
    usernames << user['login']
  end

rescue
   print "Connection error."
end


# Parse through each user for more specific data
# Makes 1 request per user
result = [];
usernames.each do |username|
  begin
    url = "https://api.github.com/users/#{username}"
    uri = URI(url)
    resp = Net::HTTP.get(uri)
    user = JSON.parse(resp)
    result << [user['login'], user['name'], user['location'], user['public_repos']]
    break if result.length == 10

  rescue
     print "Connection error."
  end
end


# CSV file creation
CSV.open("top_10_github_NY.csv", "wb") do |csv|
  csv << ["login", "name", "location", "repo count"]

  result.each do |user|
    csv << user
  end
end
