  class UserSerializer
    include FastJsonapi::ObjectSerializer
    attributes :name, :image, :twitch_id
  end