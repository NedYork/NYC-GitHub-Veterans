require 'net/http'
require 'json'
require 'csv'

require 'byebug'

# GET Request For All Users in NY- GitHub API
# Returns ordered list of usernames of users in a specific location
def usernames_get(location)
  location_query = location.split(" ").join("+")

  begin
    #sorts by location: new york and in order which user joined GitHub
    url = "https://api.github.com/search/users?q=location%3A" + location_query + "&sort=joined&order=asc"
    resp = Net::HTTP.get(URI(url))
    data = JSON.parse(resp)['items']
    usernames = data.map { |user| user['login'] }
  rescue
     print "Connection error."
  end

  [usernames, location]
end

# Parse through each user for more specific data
# Makes 1 request per user
# Likely a better way to do this
def grab_user_data(name_location_array)
  result = [];
  usernames_array = name_location_array.first
  location = name_location_array.last.split(" ")
  location_regex = "#{location.join(".?")}"

  usernames_array.each do |username|
    begin
      url = "https://api.github.com/users/#{username}"
      resp = Net::HTTP.get(URI(url))
      user = JSON.parse(resp)
      next unless user['location'] =~ Regexp.new(location_regex, "i")
      result << [user['login'], user['name'], user['location'], user['public_repos']]
      break if result.length == 10
    rescue
       print "Connection error."
    end
  end
  result

end


# CSV file creation
def csv_create(user_data_array)
  CSV.open("top_10_github_NY.csv", "wb") do |csv|
    csv << ["login", "name", "location", "repo count"]

    user_data_array.each do |user|
      csv << user
    end
  end
end

# can specify which location
# e.g. usernames_get("san francisco")
usernames = usernames_get("san francisco")
user_data = grab_user_data(usernames)
csv_create(user_data)
