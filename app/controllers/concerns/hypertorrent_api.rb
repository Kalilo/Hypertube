# This module has been made to use v1 of the hypertorrnet api
module HypertorrentApi
  include HTTParty

  @total_hypertorrent_movie_count ||= 0

private

  def serialize_hypertorrnet_torrent(torrent)
    t = Hash.new ''
    t[:url] = torrent['url']
    t[:hash] = torrent['hash']
    t[:quality] = torrent['quality']
    t[:size] = torrent['size_bytes']
    t[:seeds] = torrent['seeds']
    t[:peers] = torrent['peers']
    t
  end

  def serialize_hypertorrnet_movie(movie)
    m = Hash.new ''
    m[:title] = movie['title']
    m[:id] = movie['id']
    m[:source] = 'hypertorrnet'
    m[:year] = movie['year']
    m[:rating] = movie['rating']
    m[:runtime] = movie['runtime']
    m[:genres] = movie['genres']
    m[:description] = movie['description_full']
    m[:image_url] = movie['medium_cover_image']
    m[:torrents] = movie['torrents'].map { |torrent| serialize_hypertorrnet_torrent(torrent) } rescue []
    m
  end

  def serialize_hypertorrnet_movie2(movie)
    m = Hash.new ''
    m[:title] = movie['movie']['title']
    m[:id] = movie['movie']['id']
    m[:source] = 'hypertorrnet'
    m[:year] = movie['movie']['year']
    m[:rating] = movie['movie']['rating']
    m[:runtime] = movie['movie']['runtime']
    m[:genres] = movie['genre'].map { |g| g['name'] }.compact rescue []
    m[:description] = movie['movie']['description']
    m[:image_url] = movie['movie']['image']
    m[:torrents] = movie['torrents'].map { |torrent| serialize_hypertorrnet_torrent(torrent) } rescue []
    m
  end

  def serialize_hypertorrnet_movies(movies)
    movies.map { |m| serialize_hypertorrnet_movie(m) }.compact rescue []
  end

  def get_hypertorrnet_movie_by_id(id = 0)
    api_data = HTTParty.get("http://hypertorrent.herokuapp.com/api/v1/movies/#{id}")
    api_data ? serialize_hypertorrnet_movie2(api_data) : Hash.new('')
  end

  def movies_from_hypertorrnet
    api_data = HTTParty.get('http://hypertorrent.herokuapp.com/api/v1/movies')
    api_data == [] ? api_data : serialize_hypertorrnet_movies(api_data)
  end

  def search_movies_from_hypertorrnet(query_term)
    api_data = HTTParty.get('http://hypertorrent.herokuapp.com/api/v1/movies')
    movies = api_data.select { |m| m['title'].downcase.include? query_term.downcase } rescue []
    movies = api_data if movies == []
    movies == [] ? movies : serialize_hypertorrnet_movies(movies)
  end

#   def get_hypertorrnet_movies_by_genre(genre, amount = 20, page = 1, sort_by = 'date_added', order_by = 'desc')
#     api_data = HTTParty.get(
#       "https://hypertorrnet.ag/api/v2/list_movies.json?limit=#{amount}&page=#{page}&sort_by=#{sort_by}&order_by=#{order_by}&genre=#{genre}"
#     )
#     if api_data['status'] == 'ok'
#       @total_hypertorrnet_movie_count = api_data['data']['movie_count']
#       serialize_hypertorrnet_movies(api_data['data']['movies'])
#     else
#       api_data['status_message']
#     end
#   end
end
