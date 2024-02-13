# app/services/iterable_service.rb

require 'net/http'
require 'json'

class IterableService
  BASE_URL = ENV['ITERABLE_BASE_URL']
  API_KEY = ENV['ITERABLE_API_KEY']

  class << self
    # Public: Create or update a user in Iterable.
    def create_or_update_user(user)
      make_request('/api/users/update', method: :post, body: { email: user.email })
    end

    # Public: Track an event for a user in Iterable.
    def track_event(event, user_email)
      payload = {
        events: [{
          email: user_email,
          eventName: event.name,
          id: event.id,
          createdAt: event.created_at,
          createNewFields: true
        }]
      }
      make_request('/api/events/track', method: :post, body: payload)
    end

    # Public: Send a targeted email to a user in Iterable.
    def send_email_target(user)
      payload = {
        campaignId: 0,
        recipientEmail: user.email,
        dataFields: { message: 'event B email notification' },
        sendAt: Time.now
      }
      make_request('/api/email/target', method: :post, body: payload)
    end

    private

    # Private: Make an HTTP request to the Iterable API.
    def make_request(endpoint, method:, body: {})
      uri = URI.parse("#{BASE_URL}#{endpoint}")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true # Enable SSL for HTTPS

      request = Net::HTTP.const_get(method.capitalize).new(uri.path, 'Content-Type' => 'application/json')
      request['Authorization'] = "Bearer #{API_KEY}"
      request.body = body.to_json unless body.empty?

      response = http.request(request)
      handle_response(response)
    end

    # Private: Handle the API response based on HTTP status codes.
    def handle_response(response)
      case response.code.to_i
      when 200..299
        JSON.parse(response.body)
      when 401
        { error: 'Invalid API key' }
      else
        { error: 'Unexpected error' }
      end
    end
  end
end
