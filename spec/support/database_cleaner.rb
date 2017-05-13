#Reworked config. See http://stackoverflow.com/questions/21922046/deadlock-detected-with-capybara-webkit
RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before :suite do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around( :each ) do |spec|
    if spec.metadata[:js]
      # JS => doesn't share connections => can't use transactions
      spec.run
      Capybara.reset_sessions!
      DatabaseCleaner.clean_with :truncation #:deletion
    else
      # No JS/Devise => run with Rack::Test => transactions are ok
      DatabaseCleaner.start
      spec.run
      DatabaseCleaner.clean

      # see https://github.com/bmabey/database_cleaner/issues/99
      begin
        ActiveRecord::Base.connection.send :rollback_transaction_records, true
      rescue
      end
    end
  end

end
