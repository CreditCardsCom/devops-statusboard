defmodule Dashboard.Repo.Migrations.CreateDashboard.Backends.Backend do
  use Ecto.Migration

  def change do
    create table(:backends_backends) do
      add :slug, :string

      timestamps()
    end

  end
end
