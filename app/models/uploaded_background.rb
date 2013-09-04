class UploadedBackground
  attr_reader :file_uri
  def initialize(uploaded_file_io)
    @uploaded_io = uploaded_file_io
  end

  def save
    filename = SecureRandom.hex + File.extname(@uploaded_io.original_filename)
    filepath = Rails.root.join('public','uploads', 'maps', filename)
    @file_uri = '/uploads/maps/' + filename
    File.open(filepath, 'w') do |file|
      file.write( @uploaded_io.read )
    end

    self
  end
end
