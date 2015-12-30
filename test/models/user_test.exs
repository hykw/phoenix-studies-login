defmodule LoginStudy.UserTest do
  use LoginStudy.ModelCase

  alias LoginStudy.User

  @valid_attrs %{email: "some content", hashed_password: "some content", lastlogin_at: "2010-04-17 14:00:00"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
