defmodule PaymongoExampleWeb.ItemController do
  use PaymongoExampleWeb, :controller

  alias PaymongoExample.Sales, as: Sales
  alias PaymongoExample.Sales.Item, as: Item

  def index(conn, params) do
    changeset = Sales.change_item(%Item{})
    render(conn, "index.html", changeset: changeset, action: Routes.item_path(conn, :create))
  end

  def create(conn, %{"item" => params} = _params) do
    case Sales.create_item(params) do
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render("index.html", changeset: changeset)

      {:ok, item} ->
        conn
        |> redirect(to: Routes.item_path(conn, :index))
    end
  end
end
