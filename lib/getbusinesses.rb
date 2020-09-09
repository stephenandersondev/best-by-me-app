#This class makes calls to the Yelp API.
class GetBusinesses

    API_KEY = ENV["YELP_KEY"]

    URL = "https://api.yelp.com/v3/businesses/search"

    #Method receives user's input and calls the API with it.
    def self.search(term:, location:)
        params = {
            term: term,
            location: location,
            limit:  10,
            sort_by: "rating",
            radius: 16000
            }
    response = HTTP.auth("Bearer #{API_KEY}").get(URL, params: params)
    response.parse
    end
end