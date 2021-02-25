defmodule AssisiWeb.DonationController do
  use AssisiWeb, :controller

  alias Assisi.Classes
  alias Assisi.Classes.Donation

  plug :authenticate_user
  when action in [
    :index,
    :new,
    :create,
    :show,
    :edit,
    :update,
    :delete
  ]

  defp authenticate_user(conn, _params) do
    if Coherence.current_user(conn) &&
      Coherence.current_user(conn).admin do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to access that page.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt
    end
  end

  def index(conn, _params) do
    donations = Classes.list_donations()
    render(conn, "index.html", donations: donations)
  end

  def new(conn, _params) do
    changeset = Classes.change_donation(%Donation{})
    classes = Classes.list_classes()
    students = Classes.list_students_without_referrers()
    render(
      conn,
      "new.html",
      changeset: changeset,
      classes: classes,
      students: students
    )
  end

  def create(conn, %{"donation" => donation_params}) do
    case Classes.create_donation(donation_params) do
      {:ok, donation} ->
        conn
        |> put_flash(:info, "Donation created successfully.")
        |> redirect(to: Routes.donation_path(conn, :show, donation))

      {:error, %Ecto.Changeset{} = changeset} ->
        classes = Classes.list_classes()
        students = Classes.list_students_without_referrers()
        render(
          conn,
          "new.html",
          changeset: changeset,
          classes: classes,
          students: students
        )
    end
  end

  def show(conn, %{"id" => id}) do
    donation = Classes.get_donation!(id)
    render(conn, "show.html", donation: donation)
  end

  def edit(conn, %{"id" => id}) do
    donation = Classes.get_donation!(id)
    classes = Classes.list_classes()
    students = Classes.list_students_without_referrers()
    changeset = Classes.change_donation(donation)
    render(
      conn,
      "edit.html",
      donation: donation,
      changeset: changeset,
      classes: classes,
      students: students
    )
  end

  def update(conn, %{"id" => id, "donation" => donation_params}) do
    donation = Classes.get_donation!(id)

    case Classes.update_donation(donation, donation_params) do
      {:ok, donation} ->
        conn
        |> put_flash(:info, "Donation updated successfully.")
        |> redirect(to: Routes.donation_path(conn, :show, donation))

      {:error, %Ecto.Changeset{} = changeset} ->
        classes = Classes.list_classes()
        students = Classes.list_students_without_referrers()
        render(
          conn,
          "edit.html",
          donation: donation,
          changeset: changeset,
          classes: classes,
          students: students
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    donation = Classes.get_donation!(id)
    {:ok, _donation} = Classes.delete_donation(donation)

    conn
    |> put_flash(:info, "Donation deleted successfully.")
    |> redirect(to: Routes.donation_path(conn, :index))
  end
end
