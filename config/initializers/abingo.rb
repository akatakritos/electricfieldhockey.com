def ab_require(file)
  require File.join(Rails.root, "lib", "abingo", file)
end

require File.join(Rails.root, "lib", "abingo", "abingo.rb")
if Rails::VERSION::MAJOR >= 3
  require File.join(Rails.root, 'lib/abingo/generators/abingo_migration/abingo_migration_generator.rb')

  [
   "abingo/conversion_rate.rb",
   "abingo/alternative.rb",
   "abingo/statistics.rb",
   "abingo/experiment.rb",
   "abingo/controller/dashboard.rb",
   "abingo_sugar.rb",
   "abingo_view_helper.rb",
  ].each { |f| ab_require f }

end

ActionController::Base.send :include, AbingoSugar

ActionView::Base.send :include, AbingoViewHelper

Abingo.options[:enable_specification] = true unless Rails.env.production?
