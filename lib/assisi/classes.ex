defmodule Assisi.Classes do
  @moduledoc """
  The Classes context.
  """

  import Ecto.Query, warn: false
  alias Assisi.Repo

  alias Assisi.Classes.Student

  @doc """
  Returns the list of students.

  ## Examples

      iex> list_students_with_referrers()
      [%Student{}, ...]

  """
  def list_students_with_referrers do
    query =
      from s in Student,
        order_by: [:last_name, :first_name],
        preload: [:referrer]

    Repo.all(query)
  end

  def list_students_without_referrers do
    query =
      from s in Student,
      order_by: [:last_name, :first_name]

    Repo.all(query)
  end

  @doc """
  Gets a single student.

  Raises `Ecto.NoResultsError` if the Student does not exist.

  ## Examples

      iex> get_student!(123)
      %Student{}

      iex> get_student!(456)
      ** (Ecto.NoResultsError)

  """
  def get_student!(id) do
    student =
      Repo.one!(
        from student in Student,
          where: student.id == ^id,
          preload: [
            serieses: [:class],
            drop_ins: [:class],
            floaters_passes: [],
            first_times: [:class],
            donations: [:class],
            referrer: []
          ]
      )

    student
  end

  def get_referrals(id) do
    query = from s in Student,
      where: s.referrer_id == ^id

    Repo.all(query)
  end

  @doc """
  Creates a student.

  ## Examples

      iex> create_student(%{field: value})
      {:ok, %Student{}}

      iex> create_student(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_student(attrs \\ %{}) do
    %Student{}
    |> Student.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a student.

  ## Examples

      iex> update_student(student, %{field: new_value})
      {:ok, %Student{}}

      iex> update_student(student, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_student(%Student{} = student, attrs) do
    student
    |> Student.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Student.

  ## Examples

      iex> delete_student(student)
      {:ok, %Student{}}

      iex> delete_student(student)
      {:error, %Ecto.Changeset{}}

  """
  def delete_student(%Student{} = student) do
    Repo.delete(student)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking student changes.

  ## Examples

      iex> change_student(student)
      %Ecto.Changeset{source: %Student{}}

  """
  def change_student(%Student{} = student) do
    Student.changeset(student, %{})
  end

  alias Assisi.Classes.Class

  @doc """
  Returns the list of classes.

  ## Examples

      iex> list_classes()
      [%Class{}, ...]

  """
  def list_classes do
    query = from c in Class,
      order_by: [asc: c.recurrent_or_one_time, desc: [c.class_date, c.end_date]]

    Repo.all(query)
  end

  @doc """
  Gets a single class.

  Raises `Ecto.NoResultsError` if the Class does not exist.

  ## Examples

      iex> get_class!(123)
      %Class{}

      iex> get_class!(456)
      ** (Ecto.NoResultsError)

  """
  def get_class!(id), do: Repo.get!(Class, id)

  @doc """
  Creates a class.

  ## Examples

      iex> create_class(%{field: value})
      {:ok, %Class{}}

      iex> create_class(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_class(attrs \\ %{}) do
    %Class{}
    |> Class.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a class.

  ## Examples

      iex> update_class(class, %{field: new_value})
      {:ok, %Class{}}

      iex> update_class(class, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_class(%Class{} = class, attrs) do
    class
    |> Class.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Class.

  ## Examples

      iex> delete_class(class)
      {:ok, %Class{}}

      iex> delete_class(class)
      {:error, %Ecto.Changeset{}}

  """
  def delete_class(%Class{} = class) do
    Repo.delete(class)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking class changes.

  ## Examples

      iex> change_class(class)
      %Ecto.Changeset{source: %Class{}}

  """
  def change_class(%Class{} = class) do
    Class.changeset(class, %{})
  end

  alias Assisi.Classes.Series

  @doc """
  Returns the list of series.

  ## Examples

      iex> list_series()
      [%Series{}, ...]

  """
  def list_series do
    query = from s in Series, preload: [:class, :student]

    series = Repo.all(query)

    Enum.sort(series, &(&1.student.last_name <= &2.student.last_name))
  end

  @doc """
  Gets a single series.

  Raises `Ecto.NoResultsError` if the Series does not exist.

  ## Examples

      iex> get_series!(123)
      %Series{}

      iex> get_series!(456)
      ** (Ecto.NoResultsError)

  """
  def get_series!(id) do
    Repo.get!(Series, id) |> Repo.preload(:class) |> Repo.preload(:student)
  end

  @doc """
  Creates a series.

  ## Examples

      iex> create_series(%{field: value})
      {:ok, %Series{}}

      iex> create_series(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_series(attrs \\ %{}) do
    %Series{}
    |> Series.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a series.

  ## Examples

      iex> update_series(series, %{field: new_value})
      {:ok, %Series{}}

      iex> update_series(series, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_series(%Series{} = series, attrs) do
    series
    |> Series.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Series.

  ## Examples

      iex> delete_series(series)
      {:ok, %Series{}}

      iex> delete_series(series)
      {:error, %Ecto.Changeset{}}

  """
  def delete_series(%Series{} = series) do
    Repo.delete(series)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking series changes.

  ## Examples

      iex> change_series(series)
      %Ecto.Changeset{source: %Series{}}

  """
  def change_series(%Series{} = series) do
    Series.changeset(series, %{})
  end

  alias Assisi.Classes.DropIn

  @doc """
  Returns the list of drop_ins.

  ## Examples

      iex> list_drop_ins()
      [%DropIn{}, ...]

  """
  def list_drop_ins do
    query = from di in DropIn, preload: [:student, :class]

    drop_ins = Repo.all(query)

    Enum.sort(drop_ins, &(&1.student.last_name <= &2.student.last_name))
  end

  @doc """
  Gets a single drop_in.

  Raises `Ecto.NoResultsError` if the Drop in does not exist.

  ## Examples

      iex> get_drop_in!(123)
      %DropIn{}

      iex> get_drop_in!(456)
      ** (Ecto.NoResultsError)

  """
  def get_drop_in!(id) do
    Repo.get!(DropIn, id) |> Repo.preload(:student) |> Repo.preload(:class)
  end

  @doc """
  Creates a drop_in.

  ## Examples

      iex> create_drop_in(%{field: value})
      {:ok, %DropIn{}}

      iex> create_drop_in(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_drop_in(attrs \\ %{}) do
    %DropIn{}
    |> DropIn.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a drop_in.

  ## Examples

      iex> update_drop_in(drop_in, %{field: new_value})
      {:ok, %DropIn{}}

      iex> update_drop_in(drop_in, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_drop_in(%DropIn{} = drop_in, attrs) do
    drop_in
    |> DropIn.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a DropIn.

  ## Examples

      iex> delete_drop_in(drop_in)
      {:ok, %DropIn{}}

      iex> delete_drop_in(drop_in)
      {:error, %Ecto.Changeset{}}

  """
  def delete_drop_in(%DropIn{} = drop_in) do
    Repo.delete(drop_in)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking drop_in changes.

  ## Examples

      iex> change_drop_in(drop_in)
      %Ecto.Changeset{source: %DropIn{}}

  """
  def change_drop_in(%DropIn{} = drop_in) do
    DropIn.changeset(drop_in, %{})
  end

  alias Assisi.Classes.FloatersPass

  @doc """
  Returns the list of floaters_passes.

  ## Examples

      iex> list_floaters_passes()
      [%FloatersPass{}, ...]

  """
  def list_floaters_passes do
    query = from fp in FloatersPass, preload: [:student]

    floaters_passes = Repo.all(query)

    Enum.sort(floaters_passes, &(&1.student.last_name <= &2.student.last_name))
  end

  @doc """
  Gets a single floaters_pass.

  Raises `Ecto.NoResultsError` if the Floaters pass does not exist.

  ## Examples

      iex> get_floaters_pass!(123)
      %FloatersPass{}

      iex> get_floaters_pass!(456)
      ** (Ecto.NoResultsError)

  """
  def get_floaters_pass!(id) do
    Repo.get!(FloatersPass, id) |> Repo.preload(:student)
  end

  @doc """
  Creates a floaters_pass.

  ## Examples

      iex> create_floaters_pass(%{field: value})
      {:ok, %FloatersPass{}}

      iex> create_floaters_pass(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_floaters_pass(attrs \\ %{}) do
    %FloatersPass{}
    |> FloatersPass.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a floaters_pass.

  ## Examples

      iex> update_floaters_pass(floaters_pass, %{field: new_value})
      {:ok, %FloatersPass{}}

      iex> update_floaters_pass(floaters_pass, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_floaters_pass(%FloatersPass{} = floaters_pass, attrs) do
    floaters_pass
    |> FloatersPass.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a FloatersPass.

  ## Examples

      iex> delete_floaters_pass(floaters_pass)
      {:ok, %FloatersPass{}}

      iex> delete_floaters_pass(floaters_pass)
      {:error, %Ecto.Changeset{}}

  """
  def delete_floaters_pass(%FloatersPass{} = floaters_pass) do
    Repo.delete(floaters_pass)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking floaters_pass changes.

  ## Examples

      iex> change_floaters_pass(floaters_pass)
      %Ecto.Changeset{source: %FloatersPass{}}

  """
  def change_floaters_pass(%FloatersPass{} = floaters_pass) do
    FloatersPass.changeset(floaters_pass, %{})
  end

  alias Assisi.Classes.FirstTime

  @doc """
  Returns the list of first_times.

  ## Examples

      iex> list_first_times()
      [%FirstTime{}, ...]

  """
  def list_first_times do
    query = from ft in FirstTime, preload: [:student, :class]

    first_times = Repo.all(query)

    Enum.sort(first_times, &(&1.student.last_name <= &2.student.last_name))
  end

  @doc """
  Gets a single first_time.

  Raises `Ecto.NoResultsError` if the First time does not exist.

  ## Examples

      iex> get_first_time!(123)
      %FirstTime{}

      iex> get_first_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_first_time!(id) do
    Repo.get!(FirstTime, id) |> Repo.preload(:student) |> Repo.preload(:class)
  end

  @doc """
  Creates a first_time.

  ## Examples

      iex> create_first_time(%{field: value})
      {:ok, %FirstTime{}}

      iex> create_first_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_first_time(attrs \\ %{}) do
    %FirstTime{}
    |> FirstTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a first_time.

  ## Examples

      iex> update_first_time(first_time, %{field: new_value})
      {:ok, %FirstTime{}}

      iex> update_first_time(first_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_first_time(%FirstTime{} = first_time, attrs) do
    first_time
    |> FirstTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a FirstTime.

  ## Examples

      iex> delete_first_time(first_time)
      {:ok, %FirstTime{}}

      iex> delete_first_time(first_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_first_time(%FirstTime{} = first_time) do
    Repo.delete(first_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking first_time changes.

  ## Examples

      iex> change_first_time(first_time)
      %Ecto.Changeset{source: %FirstTime{}}

  """
  def change_first_time(%FirstTime{} = first_time) do
    FirstTime.changeset(first_time, %{})
  end

  alias Assisi.Classes.Donation

  @doc """
  Returns the list of donations.

  ## Examples

      iex> list_donations()
      [%Donation{}, ...]

  """
  def list_donations do
    query = from d in Donation,
      preload: [:student, :class]

    donations = Repo.all(query)

    Enum.sort(donations, &(&1.student.last_name <= &2.student.last_name))
  end

  @doc """
  Gets a single donation.

  Raises `Ecto.NoResultsError` if the Donation does not exist.

  ## Examples

      iex> get_donation!(123)
      %Donation{}

      iex> get_donation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_donation!(id) do
    Repo.get!(Donation, id) |> Repo.preload([:class, :student])
  end

  @doc """
  Creates a donation.

  ## Examples

      iex> create_donation(%{field: value})
      {:ok, %Donation{}}

      iex> create_donation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_donation(attrs \\ %{}) do
    %Donation{}
    |> Donation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a donation.

  ## Examples

      iex> update_donation(donation, %{field: new_value})
      {:ok, %Donation{}}

      iex> update_donation(donation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_donation(%Donation{} = donation, attrs) do
    donation
    |> Donation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Donation.

  ## Examples

      iex> delete_donation(donation)
      {:ok, %Donation{}}

      iex> delete_donation(donation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_donation(%Donation{} = donation) do
    Repo.delete(donation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking donation changes.

  ## Examples

      iex> change_donation(donation)
      %Ecto.Changeset{source: %Donation{}}

  """
  def change_donation(%Donation{} = donation) do
    Donation.changeset(donation, %{})
  end
end
