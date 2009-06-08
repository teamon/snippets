  def blip
    @statuses = JSON.parse(Net::HTTP.get('api.blip.pl', '/users/teamon/statuses.json?limit=5'))
    @statuses.each do |s|
      s['body'].gsub!(/#(\w+)/, '<a href="http://blip.pl/tag/\1">#\1</a>')
      s['body'].gsub!(/(http:\/\/rdir.pl.[A-Za-z0-9]+)/, '<a href="\1">[link]</a>')
    end
    render
  end