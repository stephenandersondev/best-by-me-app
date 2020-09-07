require 'http'


class GetBusinesses

    API_KEY = "nJkIPOOTkj6xk5Qmh_TerB38xc3xzw4rfzbPw5cDyBgwyCoN3jOwC6IFYR4mVHEJgI8TQsi4Puqubb0hUqgzMGZUDrfOOrIV5DkDPB_nNomc1T3yI8_GVNOqIYRWX3Yx"

    URL = "https://api.yelp.com/v3/businesses/search"

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