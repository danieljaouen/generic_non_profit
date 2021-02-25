defmodule AssisiWeb.DonationControllerTest do
  use AssisiWeb.ConnCase

  alias Assisi.Classes

  @create_attrs %{amount: "120.5", class_date: ~D[2010-04-17]}
  @update_attrs %{amount: "456.7", class_date: ~D[2011-05-18]}
  @invalid_attrs %{amount: nil, class_date: nil}

  def fixture(:donation) do
    {:ok, donation} = Classes.create_donation(@create_attrs)
    donation
  end

  describe "index" do
    test "lists all donations", %{conn: conn} do
      conn = get(conn, Routes.donation_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Donations"
    end
  end

  describe "new donation" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.donation_path(conn, :new))
      assert html_response(conn, 200) =~ "New Donation"
    end
  end

  describe "create donation" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.donation_path(conn, :create), donation: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.donation_path(conn, :show, id)

      conn = get(conn, Routes.donation_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Donation"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.donation_path(conn, :create), donation: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Donation"
    end
  end

  describe "edit donation" do
    setup [:create_donation]

    test "renders form for editing chosen donation", %{conn: conn, donation: donation} do
      conn = get(conn, Routes.donation_path(conn, :edit, donation))
      assert html_response(conn, 200) =~ "Edit Donation"
    end
  end

  describe "update donation" do
    setup [:create_donation]

    test "redirects when data is valid", %{conn: conn, donation: donation} do
      conn = put(conn, Routes.donation_path(conn, :update, donation), donation: @update_attrs)
      assert redirected_to(conn) == Routes.donation_path(conn, :show, donation)

      conn = get(conn, Routes.donation_path(conn, :show, donation))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, donation: donation} do
      conn = put(conn, Routes.donation_path(conn, :update, donation), donation: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Donation"
    end
  end

  describe "delete donation" do
    setup [:create_donation]

    test "deletes chosen donation", %{conn: conn, donation: donation} do
      conn = delete(conn, Routes.donation_path(conn, :delete, donation))
      assert redirected_to(conn) == Routes.donation_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.donation_path(conn, :show, donation))
      end
    end
  end

  defp create_donation(_) do
    donation = fixture(:donation)
    {:ok, donation: donation}
  end
end
