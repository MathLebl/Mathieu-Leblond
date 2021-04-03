require 'test_helper'

class EpisodesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get episodes_new_url
    assert_response :success
  end

  test "should get create" do
    get episodes_create_url
    assert_response :success
  end

  test "should get index" do
    get episodes_index_url
    assert_response :success
  end

end
