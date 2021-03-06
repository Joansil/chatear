defmodule ChatAppWeb.RoomController do
  use ChatAppWeb, :controller

  alias ChatApp.Chat.Room
  alias ChatApp.Chat
  alias ChatAppWeb.Plugs.AuthUser


  plug AuthUser when action not in [:index]
  plug :authorize_user when action in [:edit, :update, :delete]

  def index(conn, _params) do
    rooms = Chat.list_rooms()
    render(conn, "index.html", rooms: rooms)
  end

  def new(conn, _params) do
    changeset = Room.changeset(%Room{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"room" => room_params}) do
    case Chat.create_room(conn.assigns.current_user, room_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Room created successfully!")
        |> redirect(to: Routes.room_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Chat.get_room!(id)
    render(conn, "show.html", room: room)
  end

  def edit(conn, %{"id" => id}) do
    room = Chat.get_room!(id)
    changeset = Chat.change_room(room)
    render(conn, "edit.html", room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Chat.get_room!(id)

    case Chat.update_room(room, room_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Room updated successfully")
        |> redirect(to: Routes.room_path(conn, :show, room))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", room: room, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Chat.get_room!(id)
    {:ok, _room} = Chat.delete_room(room)

    conn
    |> put_flash(:info, "Room deleted successfully")
    |> redirect(to: Routes.room_path(conn, :index))
  end

  defp authorize_user(conn, _params) do
    %{params: %{"id" => room_id}} = conn
    room = Chat.get_room!(room_id)

    if AuthUser.can_access?(conn.assigns.current_user, room) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized")
      |> redirect(to: Routes.room_path(conn, :index))
      |> halt()
    end
  end

end
