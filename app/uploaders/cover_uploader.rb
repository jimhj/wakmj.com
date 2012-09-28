class CoverUploader < BaseUploader

  version :normal do
    process :resize_to_limit => [130, nil]
  end

  version :small do
    process :resize_to_limit => [100, nil]
  end

  version :large do
    process :resize_to_limit => [680, nil]
  end



end