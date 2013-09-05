class UploadedBackground

  attr_reader :uri

  def initialize(uploaded_file_io)
    @uploaded_io = uploaded_file_io
  end

  def save
    name = filename(@uploaded_io.original_filename)
    path = filepath(name)
    @uri = fileuri(name)

    File.open(path, 'w') do |file|
      file.write( @uploaded_io.read )
    end

    self
  end

  private
    def filename(original_filename)
      SecureRandom.hex + File.extname(original_filename)
    end

    def filepath(filename)
     Rails.root.join('public','uploads', 'maps', filename)
    end

    def fileuri(filename)
      "/uploads/maps/#{filename}"
    end
end
