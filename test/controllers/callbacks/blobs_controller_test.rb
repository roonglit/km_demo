require "test_helper"

class Callbacks::BlobsControllerTest < ActionDispatch::IntegrationTest
  test "should get pdf_callback" do
    get callbacks_blobs_pdf_callback_url
    assert_response :success
  end
end
