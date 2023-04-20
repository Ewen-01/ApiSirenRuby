require "test_helper"

class SirensControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sirens_index_url
    assert_response :success
  end
end
