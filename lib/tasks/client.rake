namespace :client do
  desc 'Copies client code'
  task :copy do
    [ 'editor.js',
      'editor.min.js',
      'electricfieldhockey.js',
      'electricfieldhockey.min.js'].each do |file|
      FileUtils.cp File.join('..', 'client', 'dist', file), File.join('public', 'javascripts', file)
    end
  end
end

