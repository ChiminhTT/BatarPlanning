# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ElmOnFire.Repo.insert!(%ElmOnFire.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias BatarPlanning.Accounts.User
alias BatarPlanning.Repo

users = [
  %{name: "ChiMinh"},
  %{name: "Olaf"},
  %{name: "Rollo"},
  %{name: "Brackmar"},
  %{name: "Hary"},
  %{name: "Thorstein"},
  %{name: "Baïf"},
]

users
|> Enum.each(fn(user) ->
  %User{} |> User.changeset(user) |> Repo.insert!
end)
