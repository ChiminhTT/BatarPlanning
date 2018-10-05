defmodule BatarPlanningWeb.UserView do
  use BatarPlanningWeb, :view
  alias BatarPlanningWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      monday: user.monday,
      tuesday: user.tuesday,
      wednesday: user.wednesday,
      thursday: user.thursday,
      friday: user.friday,
      saturday: user.saturday,
      sunday: user.sunday}
  end
end
