if @search_patarn == 'chef-search'
  json.array! @suggests_chef_genre do |g|
    json.suggest_chef_genre g
  end
else
  json.array! @suggests_series do |t|
    json.suggest_series t.title
  end
  json.array! @suggests_genre do |g|
    json.suggest_genre g
  end
end
