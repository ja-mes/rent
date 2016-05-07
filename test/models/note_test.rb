require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  def setup
    @note = notes(:one)
  end

  test "note should be valid" do
    assert notes(:one).valid?
  end

  test "note should belong to user" do
    assert users(:one).notes
  end

  test "user should be present on note" do
    @note.user = nil
    assert_not @note.valid?
  end

  test "customer should be present" do
    @note.customer = nil
    assert_not @note.valid?
  end

  test "content should be present" do
    @note.content = "  "
    assert_not @note.valid?
  end
end
