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

def colorize(var, format = nil)
  color = if var.is_a?(Numeric)
    var >= 0 ? :green : :red
  else
    var ? :green : :red
  end
  
  var = format % var if format
  '<span style="color: %s">%s</span>' % [color, var]
end