defmodule ChatAppWeb.RegistrationController do
  use ChatAppWeb, :controller

  def new(conn, _) do
    render(conn, "new.html", changeset: conn)
  end

  def create(_conn, _params) do
  end
end
