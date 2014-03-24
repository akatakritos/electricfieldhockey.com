namespace :client do
  desc 'Copies client code'
  task :copy do
    [ 'editor.js',
      'game.js',
      'game.min.js',
      'simulation.js',
      'simulation.min.js'].each do |file|
      FileUtils.cp File.join('..', 'client', 'dist', file), File.join('public', 'javascripts', file)
    end
  end
end

