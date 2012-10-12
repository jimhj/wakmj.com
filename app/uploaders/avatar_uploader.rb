class AvatarUploader < BaseUploader

  version :small do
    process :resize_to_fill => [50, 50]
  end

  version :big do
    process :resize_to_fill => [180, 180]
  end

  version :large do
    process :resize_to_limit => [680, nil]
  end

  def default_url
    "avatar/avatar_#{version_name}.jpg"
  end

end