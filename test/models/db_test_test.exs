defmodule LoginStudy.DBTestTest do
  use LoginStudy.ModelCase

  alias LoginStudy.DBTest

  @valid_attrs %{hashed_password: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DBTest.changeset(%DBTest{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DBTest.changeset(%DBTest{}, @invalid_attrs)
    refute changeset.valid?
  end
end
