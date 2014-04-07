require 'google/api_client'
require 'date'

class GoogleAnalytics
  # https://developers.google.com/analytics/devguides/reporting/core/v3/reference#q_summary
  # https://github.com/google/google-api-ruby-client-samples/blob/master/service_account/analytics.rb
  APP_NAME              = ENV['GA_APP_NAME']
  PROFILE_ID            = ENV['GA_PROFILE_ID']
  SERVICE_ACCOUNT_EMAIL = ENV['GA_SERVICE_ACCOUNT_EMAIL']
  KEY_FILE_NAME         = ENV['GA_KEY_FILE_NAME']

  def initialize
    @client  = Google::APIClient.new(:application_name => APP_NAME, :application_version => '1.0')
    key_file = File.join('config', KEY_FILE_NAME)
    key      = Google::APIClient::PKCS12.load_key(key_file, 'notasecret')


    service_account = Google::APIClient::JWTAsserter.new(
        SERVICE_ACCOUNT_EMAIL,
        ['https://www.googleapis.com/auth/analytics.readonly', 'https://www.googleapis.com/auth/prediction'],
        key)
    @client.authorization = service_account.authorize

    @analytics = @client.discovered_api('analytics', 'v3')
  end

  def visitors(startDate, endDate)
    results = @client.execute(:api_method => @analytics.data.ga.get, :parameters => {
      'ids'         => "ga:" + PROFILE_ID,
      'start-date'  => startDate,
      'end-date'    => endDate,
      'metrics'     => "ga:visitors",
      'dimensions'  => "ga:year,ga:month,ga:day",
      'sort'        => "ga:year,ga:month,ga:day"
    })

    hash = {}

    results.data.rows.each do |r|
      hash["#{r[0]}-#{r[1]}-#{r[2]}"] = r[3].to_i
    end

    return hash
  end
end