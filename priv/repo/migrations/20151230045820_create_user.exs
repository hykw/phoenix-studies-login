defmodule LoginStudy.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :hashed_password, :string
      add :lastlogin_at, :datetime

      timestamps
    end

  end
end
