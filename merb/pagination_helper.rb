module Merb
  module PaginationHelper
    # Given a dataset we generate a set of pagination links.
    # 
    # * Options
    # :prev_label => <em>text_for_previous_link</em>::
    #    Defaults to '&laquo; Previous '
    # :next_labe => <em>text_for_next_link</em>::
    #    Defaults to ' Next &raquo;'
    # :left_cut_label => <em>text_for_cut</em>::
    #    Used when the page numbers need to be cut off to prevent the set of
    #    pagination links from being too long.
    #    Defaults to '&larr;'
    # :right_cut_label => <em>text_for_cut</em>::
    #    Same as :left_cut_label but for the right side of numbers.
    #    Defaults to '&rarr;'
    # :outer_window => <em>number_of_pages</em>::
    #    Sets the number of pages to include in the outer 'window'
    #    Defaults to 2
    # :inner_window => <em>number_of_pages</em>::
    #    Sets the number of pags to include in the inner 'window'
    #    Defaults to 10
    # :default_css => <em>use_paginator_provided_css</em>
    #    Use the default CSS provided by the paginator. If you want to do
    #    your own custom styling of the paginator from scratch, set this to 
    #    false.
    #    Defaults to true
    # :page_param => <em>name_of_page_paramiter</em>
    #    Sets the name of the paramiter the paginator uses to return what
    #    page is being requested.
    #    Defaults to 'page'
    # :route => <em>url_for_links</em>
    #    Provides the base url to use in the page navigation links.
    #    Defaults to ''
    def paginate(dataset, options = {})
      
      opts = {
        :first_last => true,
        :prev_next => true,
        :current_page => true,
        :first_label => '&laquo; First',
        :prev_label => '&laquo; Previous',
        :next_label => 'Next &raquo;',
        :last_label => 'Last &raquo;',
        :size => 3,
        :page_param => 'page',
        :route => @request.route.name
      }.merge(options)
      
      if dataset.is_a?(Sequel::Dataset)
        current_page = dataset.current_page
        page_count = dataset.page_count
      elsif dataset.is_a?(Array)        
        current_page = dataset.first
        page_count = dataset.last
      else
        raise ArgumentError
      end
      
      return "" if page_count <= 1
      
      items = []
      items << [1, opts[:first_label], 'first'] if opts[:first_last] && current_page > 2
      items << [current_page - 1, opts[:prev_label], 'next'] if opts[:prev_next] && current_page > 1
      ((current_page-opts[:size] < 1 ? 1 : current_page-opts[:size])...current_page).each {|i| items << [i, i] }
      items << [current_page, "[#{current_page}]"] if opts[:current_page]
      ((current_page+1)..(current_page+opts[:size] > page_count ? page_count : current_page+opts[:size])).each {|i| items << [i, i] }
      items << [current_page + 1, opts[:next_label], 'prev'] if opts[:prev_next] && current_page < page_count
      items << [page_count, opts[:last_label], 'last'] if opts[:first_last] && current_page < page_count - 1
        
        
      new_params = params.dup  
      new_params.delete(:action)
      new_params.delete(:controller)      
      items.map do |page, label, class_name|
        if page == current_page
          %Q(<span>#{page}</span>)
        else
          new_params[:page] = page
          css_class = class_name && %Q( class="#{class_name}")
          %Q(<a href="#{url(opts[:route], new_params)}"#{css_class}>#{label}</a>)
        end        
      end.join " "
    end
  end
end
