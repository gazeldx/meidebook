class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  before :cache, :valid_size?

  def store_dir
    "#{Sinatra::Application.settings.root}/public/uploads/comments/#{model.id}"
  end

  def valid_size?(file)
    raise CarrierWave::IntegrityError, I18n.translate('comment.photo_too_big') if file.size > 4500000
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process resize_to_limit: [690, nil]
  # process :resize_to_fit => [width, height]

  version :thumb do
    process resize_to_limit: [170, nil]
  end

  version :square do
    process :resize_to_fill => [115, 115]
  end

  def filename
    begin
      "photo#{File.extname(super).downcase}"
    rescue
      ''
    end
  end
end
