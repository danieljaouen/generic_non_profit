defmodule Assisi.ClassesTest do
  use Assisi.DataCase

  alias Assisi.Repo
  alias Assisi.Classes
  alias Assisi.Classes.Class
  alias Assisi.Classes.Student

  setup do
    student =
      Repo.insert!(%Student{first_name: "first", last_name: "last", id: 1})
      |> Repo.preload([:serieses, :drop_ins, :floaters_passes, :first_times])

    class = Repo.insert!(%Class{name: "some class", id: 1})
    {:ok, student: student, class: class}
  end

  describe "students" do
    alias Assisi.Classes.Student

    @valid_attrs %{
      email: "some email",
      first_name: "some first_name",
      last_name: "some last_name",
      id: 2
    }
    @update_attrs %{
      email: "some updated email",
      first_name: "some updated first_name",
      last_name: "some updated last_name",
      id: 2
    }
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil}

    def student_fixture(attrs \\ %{}) do
      {:ok, student} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Classes.create_student()

      student |> Repo.preload([:serieses, :drop_ins, :floaters_passes, :first_times])
    end

    test "list_students/0 returns all students", %{student: student} do
      student_ = student_fixture()

      assert Classes.list_students_with_referrers()
             |> Repo.preload([:serieses, :drop_ins, :floaters_passes, :first_times]) == [
               student,
               student_
             ]
    end

    test "get_student!/1 returns the student with given id" do
      student = student_fixture()
      assert Classes.get_student!(student.id) == student
    end

    test "create_student/1 with valid data creates a student" do
      assert {:ok, %Student{} = student} = Classes.create_student(@valid_attrs)
      assert student.email == "some email"
      assert student.first_name == "some first_name"
      assert student.last_name == "some last_name"
    end

    test "create_student/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classes.create_student(@invalid_attrs)
    end

    test "update_student/2 with valid data updates the student" do
      student = student_fixture()
      assert {:ok, %Student{} = student} = Classes.update_student(student, @update_attrs)
      assert student.email == "some updated email"
      assert student.first_name == "some updated first_name"
      assert student.last_name == "some updated last_name"
    end

    test "update_student/2 with invalid data returns error changeset" do
      student = student_fixture()
      assert {:error, %Ecto.Changeset{}} = Classes.update_student(student, @invalid_attrs)
      assert student == Classes.get_student!(student.id)
    end

    test "delete_student/1 deletes the student" do
      student_ = student_fixture()
      assert {:ok, %Student{}} = Classes.delete_student(student_)
      assert_raise Ecto.NoResultsError, fn -> Classes.get_student!(student_.id) end
    end

    test "change_student/1 returns a student changeset" do
      student = student_fixture()
      assert %Ecto.Changeset{} = Classes.change_student(student)
    end
  end

  describe "classes" do
    alias Assisi.Classes.Class

    @valid_attrs %{
      name: "some name",
      class_date: ~D[2010-04-17],
      drop_in_cost: 42,
      end_date: ~D[2010-04-17],
      recurrent_or_one_time: "some recurrent_or_one_time",
      start_date: ~D[2010-04-17]
    }
    @update_attrs %{
      name: "some name",
      class_date: ~D[2011-05-18],
      drop_in_cost: 43,
      end_date: ~D[2011-05-18],
      recurrent_or_one_time: "some updated recurrent_or_one_time",
      start_date: ~D[2011-05-18]
    }
    @invalid_attrs %{
      class_date: nil,
      drop_in_cost: nil,
      end_date: nil,
      recurrent_or_one_time: nil,
      start_date: nil
    }

    def class_fixture(attrs \\ %{}) do
      {:ok, class} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Classes.create_class()

      class
    end

    test "list_classes/0 returns all classes", %{class: class} do
      class_ = class_fixture()
      assert Classes.list_classes() == [class, class_]
    end

    test "get_class!/1 returns the class with given id" do
      class = class_fixture()
      assert Classes.get_class!(class.id) == class
    end

    test "create_class/1 with valid data creates a class" do
      assert {:ok, %Class{} = class} = Classes.create_class(@valid_attrs)
      assert class.class_date == ~D[2010-04-17]
      assert class.drop_in_cost == Decimal.new(42)
      assert class.end_date == ~D[2010-04-17]
      assert class.recurrent_or_one_time == "some recurrent_or_one_time"
      assert class.start_date == ~D[2010-04-17]
    end

    test "create_class/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classes.create_class(@invalid_attrs)
    end

    test "update_class/2 with valid data updates the class" do
      class = class_fixture()
      assert {:ok, %Class{} = class} = Classes.update_class(class, @update_attrs)
      assert class.class_date == ~D[2011-05-18]
      assert class.drop_in_cost == Decimal.new(43)
      assert class.end_date == ~D[2011-05-18]
      assert class.recurrent_or_one_time == "some updated recurrent_or_one_time"
      assert class.start_date == ~D[2011-05-18]
    end

    test "update_class/2 with invalid data returns error changeset" do
      class = class_fixture()
      assert {:error, %Ecto.Changeset{}} = Classes.update_class(class, @invalid_attrs)
      assert class == Classes.get_class!(class.id)
    end

    test "delete_class/1 deletes the class" do
      class = class_fixture()
      assert {:ok, %Class{}} = Classes.delete_class(class)
      assert_raise Ecto.NoResultsError, fn -> Classes.get_class!(class.id) end
    end

    test "change_class/1 returns a class changeset" do
      class = class_fixture()
      assert %Ecto.Changeset{} = Classes.change_class(class)
    end
  end

  describe "series" do
    alias Assisi.Classes.Series

    @valid_attrs %{timeslot: "some timeslot", class_id: 1, student_id: 1}
    @update_attrs %{timeslot: "some updated timeslot", class_id: 1, student_id: 1}
    @invalid_attrs %{timeslot: nil}

    def series_fixture(attrs \\ %{}) do
      {:ok, series} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Classes.create_series()

      series |> Repo.preload([:student, :class])
    end

    test "list_series/0 returns all series" do
      series = series_fixture()
      assert Classes.list_series() == [series]
    end

    test "get_series!/1 returns the series with given id" do
      series = series_fixture()
      assert Classes.get_series!(series.id) == series
    end

    test "create_series/1 with valid data creates a series" do
      assert {:ok, %Series{} = series} = Classes.create_series(@valid_attrs)
      assert series.timeslot == "some timeslot"
    end

    test "create_series/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classes.create_series(@invalid_attrs)
    end

    test "update_series/2 with valid data updates the series" do
      series = series_fixture()
      assert {:ok, %Series{} = series} = Classes.update_series(series, @update_attrs)
      assert series.timeslot == "some updated timeslot"
    end

    test "update_series/2 with invalid data returns error changeset" do
      series = series_fixture()
      assert {:error, %Ecto.Changeset{}} = Classes.update_series(series, @invalid_attrs)
      assert series == Classes.get_series!(series.id)
    end

    test "delete_series/1 deletes the series" do
      series = series_fixture()
      assert {:ok, %Series{}} = Classes.delete_series(series)
      assert_raise Ecto.NoResultsError, fn -> Classes.get_series!(series.id) end
    end

    test "change_series/1 returns a series changeset" do
      series = series_fixture()
      assert %Ecto.Changeset{} = Classes.change_series(series)
    end
  end

  describe "drop_ins" do
    alias Assisi.Classes.DropIn

    @valid_attrs %{
      date: ~D[2010-04-17],
      paid: true,
      timeslot: "some timeslot",
      class_id: 1,
      student_id: 1
    }
    @update_attrs %{
      date: ~D[2011-05-18],
      paid: false,
      timeslot: "some updated timeslot",
      class_id: 1,
      student_id: 1
    }
    @invalid_attrs %{date: nil, paid: nil, timeslot: nil}

    def drop_in_fixture(attrs \\ %{}) do
      {:ok, drop_in} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Classes.create_drop_in()

      drop_in |> Repo.preload([:student, :class])
    end

    test "list_drop_ins/0 returns all drop_ins" do
      drop_in = drop_in_fixture()
      assert Classes.list_drop_ins() == [drop_in]
    end

    test "get_drop_in!/1 returns the drop_in with given id" do
      drop_in = drop_in_fixture()
      assert Classes.get_drop_in!(drop_in.id) == drop_in
    end

    test "create_drop_in/1 with valid data creates a drop_in" do
      assert {:ok, %DropIn{} = drop_in} = Classes.create_drop_in(@valid_attrs)
      assert drop_in.date == ~D[2010-04-17]
      assert drop_in.paid == true
      assert drop_in.timeslot == "some timeslot"
    end

    test "create_drop_in/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classes.create_drop_in(@invalid_attrs)
    end

    test "update_drop_in/2 with valid data updates the drop_in" do
      drop_in = drop_in_fixture()
      assert {:ok, %DropIn{} = drop_in} = Classes.update_drop_in(drop_in, @update_attrs)
      assert drop_in.date == ~D[2011-05-18]
      assert drop_in.paid == false
      assert drop_in.timeslot == "some updated timeslot"
    end

    test "update_drop_in/2 with invalid data returns error changeset" do
      drop_in = drop_in_fixture()
      assert {:error, %Ecto.Changeset{}} = Classes.update_drop_in(drop_in, @invalid_attrs)
      assert drop_in == Classes.get_drop_in!(drop_in.id)
    end

    test "delete_drop_in/1 deletes the drop_in" do
      drop_in = drop_in_fixture()
      assert {:ok, %DropIn{}} = Classes.delete_drop_in(drop_in)
      assert_raise Ecto.NoResultsError, fn -> Classes.get_drop_in!(drop_in.id) end
    end

    test "change_drop_in/1 returns a drop_in changeset" do
      drop_in = drop_in_fixture()
      assert %Ecto.Changeset{} = Classes.change_drop_in(drop_in)
    end
  end

  describe "floaters_passes" do
    alias Assisi.Classes.FloatersPass

    @valid_attrs %{
      current_uses: 42,
      expiration_date: ~D[2010-04-17],
      max_uses: 42,
      class_id: 1,
      student_id: 1
    }
    @update_attrs %{
      current_uses: 43,
      expiration_date: ~D[2011-05-18],
      max_uses: 43,
      class_id: 1,
      student_id: 1
    }
    @invalid_attrs %{current_uses: nil, expiration_date: nil, max_uses: nil}

    def floaters_pass_fixture(attrs \\ %{}) do
      {:ok, floaters_pass} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Classes.create_floaters_pass()

      floaters_pass |> Repo.preload(:student)
    end

    test "list_floaters_passes/0 returns all floaters_passes" do
      floaters_pass = floaters_pass_fixture()
      assert Classes.list_floaters_passes() == [floaters_pass]
    end

    test "get_floaters_pass!/1 returns the floaters_pass with given id" do
      floaters_pass = floaters_pass_fixture()
      assert Classes.get_floaters_pass!(floaters_pass.id) == floaters_pass
    end

    test "create_floaters_pass/1 with valid data creates a floaters_pass" do
      assert {:ok, %FloatersPass{} = floaters_pass} = Classes.create_floaters_pass(@valid_attrs)
      assert floaters_pass.current_uses == 42
      assert floaters_pass.expiration_date == ~D[2010-04-17]
      assert floaters_pass.max_uses == 42
    end

    test "create_floaters_pass/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classes.create_floaters_pass(@invalid_attrs)
    end

    test "update_floaters_pass/2 with valid data updates the floaters_pass" do
      floaters_pass = floaters_pass_fixture()

      assert {:ok, %FloatersPass{} = floaters_pass} =
               Classes.update_floaters_pass(floaters_pass, @update_attrs)

      assert floaters_pass.current_uses == 43
      assert floaters_pass.expiration_date == ~D[2011-05-18]
      assert floaters_pass.max_uses == 43
    end

    test "update_floaters_pass/2 with invalid data returns error changeset" do
      floaters_pass = floaters_pass_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Classes.update_floaters_pass(floaters_pass, @invalid_attrs)

      assert floaters_pass == Classes.get_floaters_pass!(floaters_pass.id)
    end

    test "delete_floaters_pass/1 deletes the floaters_pass" do
      floaters_pass = floaters_pass_fixture()
      assert {:ok, %FloatersPass{}} = Classes.delete_floaters_pass(floaters_pass)
      assert_raise Ecto.NoResultsError, fn -> Classes.get_floaters_pass!(floaters_pass.id) end
    end

    test "change_floaters_pass/1 returns a floaters_pass changeset" do
      floaters_pass = floaters_pass_fixture()
      assert %Ecto.Changeset{} = Classes.change_floaters_pass(floaters_pass)
    end
  end

  describe "first_times" do
    alias Assisi.Classes.FirstTime

    @valid_attrs %{date: ~D[2010-04-17], timeslot: "some timeslot", class_id: 1, student_id: 1}
    @update_attrs %{
      date: ~D[2011-05-18],
      timeslot: "some updated timeslot",
      class_id: 1,
      student_id: 1
    }
    @invalid_attrs %{date: nil, timeslot: nil}

    def first_time_fixture(attrs \\ %{}) do
      {:ok, first_time} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Classes.create_first_time()

      first_time |> Repo.preload([:student, :class])
    end

    test "list_first_times/0 returns all first_times" do
      first_time = first_time_fixture()
      assert Classes.list_first_times() == [first_time]
    end

    test "get_first_time!/1 returns the first_time with given id" do
      first_time = first_time_fixture()
      assert Classes.get_first_time!(first_time.id) == first_time
    end

    test "create_first_time/1 with valid data creates a first_time" do
      assert {:ok, %FirstTime{} = first_time} = Classes.create_first_time(@valid_attrs)
      assert first_time.date == ~D[2010-04-17]
      assert first_time.timeslot == "some timeslot"
    end

    test "create_first_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classes.create_first_time(@invalid_attrs)
    end

    test "update_first_time/2 with valid data updates the first_time" do
      first_time = first_time_fixture()

      assert {:ok, %FirstTime{} = first_time} =
               Classes.update_first_time(first_time, @update_attrs)

      assert first_time.date == ~D[2011-05-18]
      assert first_time.timeslot == "some updated timeslot"
    end

    test "update_first_time/2 with invalid data returns error changeset" do
      first_time = first_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Classes.update_first_time(first_time, @invalid_attrs)
      assert first_time == Classes.get_first_time!(first_time.id)
    end

    test "delete_first_time/1 deletes the first_time" do
      first_time = first_time_fixture()
      assert {:ok, %FirstTime{}} = Classes.delete_first_time(first_time)
      assert_raise Ecto.NoResultsError, fn -> Classes.get_first_time!(first_time.id) end
    end

    test "change_first_time/1 returns a first_time changeset" do
      first_time = first_time_fixture()
      assert %Ecto.Changeset{} = Classes.change_first_time(first_time)
    end
  end

  describe "donations" do
    alias Assisi.Classes.Donation

    @valid_attrs %{amount: "120.5", class_date: ~D[2010-04-17]}
    @update_attrs %{amount: "456.7", class_date: ~D[2011-05-18]}
    @invalid_attrs %{amount: nil, class_date: nil}

    def donation_fixture(attrs \\ %{}) do
      {:ok, donation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Classes.create_donation()

      donation
    end

    test "list_donations/0 returns all donations" do
      donation = donation_fixture()
      assert Classes.list_donations() == [donation]
    end

    test "get_donation!/1 returns the donation with given id" do
      donation = donation_fixture()
      assert Classes.get_donation!(donation.id) == donation
    end

    test "create_donation/1 with valid data creates a donation" do
      assert {:ok, %Donation{} = donation} = Classes.create_donation(@valid_attrs)
      assert donation.amount == Decimal.new("120.5")
      assert donation.class_date == ~D[2010-04-17]
    end

    test "create_donation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Classes.create_donation(@invalid_attrs)
    end

    test "update_donation/2 with valid data updates the donation" do
      donation = donation_fixture()
      assert {:ok, %Donation{} = donation} = Classes.update_donation(donation, @update_attrs)
      assert donation.amount == Decimal.new("456.7")
      assert donation.class_date == ~D[2011-05-18]
    end

    test "update_donation/2 with invalid data returns error changeset" do
      donation = donation_fixture()
      assert {:error, %Ecto.Changeset{}} = Classes.update_donation(donation, @invalid_attrs)
      assert donation == Classes.get_donation!(donation.id)
    end

    test "delete_donation/1 deletes the donation" do
      donation = donation_fixture()
      assert {:ok, %Donation{}} = Classes.delete_donation(donation)
      assert_raise Ecto.NoResultsError, fn -> Classes.get_donation!(donation.id) end
    end

    test "change_donation/1 returns a donation changeset" do
      donation = donation_fixture()
      assert %Ecto.Changeset{} = Classes.change_donation(donation)
    end
  end
end
