def default_error_messages_for(obj, opts = {})
  error_messages_for obj, :build_li => "<li>%s</li>", :header => "<h3>#{"Oops! There are some errors".t}</h3>"
end

%w(text_field password_field hidden_field file_field
text_area select check_box radio_button radio_group).each do |kind|
  self.class_eval <<-RUBY, __FILE__, __LINE__ + 1
    def labeled_#{kind}(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options[:label] = args.first.to_s.gsub('_', ' ').capitalize.t + ":" unless options[:label]
      args.push(options)
      #{kind}(*args)
    end
  RUBY
end