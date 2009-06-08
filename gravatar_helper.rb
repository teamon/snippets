    require 'digest/md5'
    def gravatar_url_for(email, opts = {})
      opts[:default] = "http://#{request.host}/images/#{opts[:default]}" if opts[:default]
      "http://www.gravatar.com/avatar.php/#{Digest::MD5.hexdigest(email || "")}?#{opts.to_params}"
    end

    def gravatar_image_for(email, opts = {})
      image_tag(gravatar_url_for(email, opts), :alt => "")
    end