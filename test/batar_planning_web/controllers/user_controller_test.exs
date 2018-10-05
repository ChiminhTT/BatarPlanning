defmodule BatarPlanningWeb.UserControllerTest do
  use BatarPlanningWeb.ConnCase

  alias BatarPlanning.Accounts
  alias BatarPlanning.Accounts.User

  @create_attrs %{friday: true, monday: true, name: "some name", saturday: true, sunday: true, thursday: true, tuesday: true, wednesday: true}
  @update_attrs %{friday: false, monday: false, name: "some updated name", saturday: false, sunday: false, thursday: false, tuesday: false, wednesday: false}
  @invalid_attrs %{friday: nil, monday: nil, name: nil, saturday: nil, sunday: nil, thursday: nil, tuesday: nil, wednesday: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "friday" => true,
        "monday" => true,
        "name" => "some name",
        "saturday" => true,
        "sunday" => true,
        "thursday" => true,
        "tuesday" => true,
        "wednesday" => true}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "friday" => false,
        "monday" => false,
        "name" => "some updated name",
        "saturday" => false,
        "sunday" => false,
        "thursday" => false,
        "tuesday" => false,
        "wednesday" => false}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, user_path(conn, :delete, user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
