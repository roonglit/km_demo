require "application_system_test_case"

class Admin::ContentsTest < ApplicationSystemTestCase
  setup do
    @admin_content = admin_contents(:one)
  end

  test "visiting the index" do
    visit admin_contents_url
    assert_selector "h1", text: "Contents"
  end

  test "should create content" do
    visit admin_contents_url
    click_on "New content"

    click_on "Create Content"

    assert_text "Content was successfully created"
    click_on "Back"
  end

  test "should update Content" do
    visit admin_content_url(@admin_content)
    click_on "Edit this content", match: :first

    click_on "Update Content"

    assert_text "Content was successfully updated"
    click_on "Back"
  end

  test "should destroy Content" do
    visit admin_content_url(@admin_content)
    click_on "Destroy this content", match: :first

    assert_text "Content was successfully destroyed"
  end
end
