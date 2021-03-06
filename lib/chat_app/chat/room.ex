defmodule ChatApp.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChatApp.Chat.Room

  schema "rooms" do
    field :description, :string
    field :name, :string
    field :topic, :string

    belongs_to :user, ChatApp.Accounts.User
    has_many :messages, ChatApp.Chat.Message

    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:name, :description, :topic])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> validate_length(:name, min: 2, max: 30)
    |> validate_length(:topic, min: 2, max: 100)
  end
end
