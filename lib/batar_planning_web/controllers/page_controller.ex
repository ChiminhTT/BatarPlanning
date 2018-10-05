defmodule BatarPlanningWeb.PageController do
  use BatarPlanningWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
