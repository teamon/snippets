def permalink(string)
  Iconv.iconv('ascii//translit//IGNORE', 'utf-8', string).first.gsub("'", '').gsub(/[^a-zA-Z0-9-]+/, '-').gsub(/^-/, '').gsub(/-$/, '')
end
