def generate_token
  require 'digest/md5'
  self.token = Digest::MD5.hexdigest(name + created_at.to_s + rand(100).to_s)
end