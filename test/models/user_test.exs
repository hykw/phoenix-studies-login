defmodule LoginStudy.UserTest do
  use LoginStudy.ModelCase

  alias LoginStudy.User

  @valid_attrs %{email: "foo@example.jp", password: "1234"}
  @invalid_attrs %{email: "foo@example.jp", password: "12345"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
