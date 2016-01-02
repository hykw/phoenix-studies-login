defmodule LoginStudy.Repo.Migrations.AddLogintimesToUsers do
  use Ecto.Migration

  # Django と違って model と migration ファイルは紐付かないので、
  # 手で alter して作った方が楽かも。

  def change do
    alter table(:users) do
      add :login_times, :integer, default: 0, null: false
    end
  end
end
