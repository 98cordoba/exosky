# app/services/open_ai_service.rb
class OpenAiService
  require 'openai'

  def self.chat(message)
    # Get the key from the credentials
    api_key = Rails.application.credentials.dig(:openai, :api_key)
    client = OpenAI::Client.new(access_token: api_key)

    begin
      response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [{ role: "user", content: message }],
          temperature: 0.7,
        }
      )
      response.dig("choices", 0, "message", "content")
    rescue Faraday::TooManyRequestsError
      # Specifically handle the quota exceeded error
      "Sorry, I've reached my capacity limit for today. Please try again later."
    rescue => e
      # Handle other potential errors
      "Error processing request: #{e.message}"
    end
  end
end
