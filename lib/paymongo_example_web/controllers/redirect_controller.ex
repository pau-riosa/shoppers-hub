defmodule PaymongoExampleWeb.RedirectController do
  use PaymongoExampleWeb, :controller

  def failed(conn, %{"payment_type" => payment_type} = _params) do
    render(conn, "index.html",
      message:
        "Payment type #{payment_type} has been failed authorized. please wait for the admin to accept your payment. "
    )
  end

  def success(conn, %{"payment_type" => payment_type} = _params) do
    render(conn, "index.html",
      message:
        "Payment type #{payment_type} has been successfully authorized. please wait for the admin to accept your payment. "
    )
  end
end
