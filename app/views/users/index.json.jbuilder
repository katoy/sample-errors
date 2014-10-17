json.array!(@users) do |user|
  json.extract! user, :id, :nmae, :tel, :email
  json.url user_url(user, format: :json)
end
