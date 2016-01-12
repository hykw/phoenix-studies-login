defmodule LoginStudy.Repo.Migrations.CreateDBTest do
  use Ecto.Migration

  def change do
    create table(:passlists) do
      add :hashed_password, :string

      timestamps
    end

  end
end
