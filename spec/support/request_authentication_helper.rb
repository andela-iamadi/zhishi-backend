module RequestAuthenticationHelper
  extend ActiveSupport::Concern
  included do
    before(:each) do
      🙈 = Dummy.create_with_methods({body: "{\"email\": \"#{valid_user.email}\"}"})
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(🙈)
    end
  end

  def valid_user
    @valid_user ||= create(:user)
  end

  def valid_user_token(user = nil)
    (user || valid_user).refresh_token
  end

  def authorization_header(token = valid_user_token)
    authorization_token(token).merge(cookie_header)
  end

  def authorization_token(token = valid_user_token)
    { authorization: "Token token=#{token}" }
  end

  def cookie_header
    { HTTP_ANDELA_COOKIE: "valid cookie" }
  end
end


RSpec.configure do |config|
  config.include RequestAuthenticationHelper, type: :request
  config.include RequestAuthenticationHelper, type: :controller
end
