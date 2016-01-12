defmodule LoginStudy.Repo.Migrations.CreateLoginHistory do
  use Ecto.Migration
  @disable_ddl_transaction true

  def change do
    create table(:login_history) do
      add :login_at, :datetime
      add :user_id, :integer

    end

    # create index(:login_history, [:user_id, :login_at], concurrently: true) にすると
    # MySQLの場合 SQL エラーになるので注意
    create index(:login_history, [:user_id, :login_at])

  end
end
