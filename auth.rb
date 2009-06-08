  def ensure_authenticated_as(klazz)
    raise Unauthenticated unless session.user.is_a?(klazz)
  end

    def number_with_delimiter(number, delimiter = ".")
      number.to_s.reverse.scan(/.{1,3}/).join(delimiter).reverse
    end
    
    def truncate(text, max_length)
      return text[0, max_length] + "..." if text.length > max_length
      text
    end