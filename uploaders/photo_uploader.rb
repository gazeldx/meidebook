class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  before :cache, :valid_file?

  def store_dir
    "#{Sinatra::Application.settings.root}/public/uploads/comments/#{model.id}"
  end

  def valid_file?(file)
    raise CarrierWave::IntegrityError, I18n.translate('comment.extension_invalid') unless %w(jpg jpeg gif png).include?(file_extension_type(file.original_filename.downcase))
    raise CarrierWave::IntegrityError, I18n.translate('comment.photo_too_big') if file.size > 9900000
  end

  def file_extension_type(file_name)
    file_name[file_name.rindex('.') + 1..file_name.length]
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

  # 不知道为什么extension_white_list在此处不起作用，只能在valid_file?中验证了
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end
end
