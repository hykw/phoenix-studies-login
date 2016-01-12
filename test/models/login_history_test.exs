defmodule LoginStudy.LoginHistoryTest do
  use LoginStudy.ModelCase

  alias LoginStudy.LoginHistory

  @valid_attrs %{login_at: "2010-04-17 14:00:00", user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = LoginHistory.changeset(%LoginHistory{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LoginHistory.changeset(%LoginHistory{}, @invalid_attrs)
    refute changeset.valid?
  end
end
