defmodule TableBooking.Request do
  @moduledoc """
  A struct representing  a request, which has a number of people and an index.

  Note: like many functional languages, Elixir has lists rather than arrays, so
  we need to make the indexes explicit.
  """

  @enforce_keys [:number_of_people, :index]
  defstruct [:number_of_people, :index]

  @doc """
  Given a list of integers representing numbers of people, wrap each one in a
  `TableBooking.Request` struct.
  """
  def new_list(requests) do
    requests
    |> Enum.with_index()
    |> Enum.map(fn {request, index} -> %__MODULE__{number_of_people: request, index: index} end)
  end
end

defmodule TableBooking.Table do
  @moduledoc """
  A struct representing a table, which may or not be booked.
  """

  @enforce_keys :capacity
  defstruct capacity: nil, booked_for: nil

  def output(table), do: "table for #{word_for(table.booked_for)}"

  defp word_for(1), do: "one"
  defp word_for(2), do: "two"
  defp word_for(3), do: "three"
  defp word_for(4), do: "four"
  defp word_for(5), do: "five"
  defp word_for(6), do: "six"
  defp word_for(7), do: "seven"
  defp word_for(8), do: "eight"
end

defmodule TableBooking do
  @moduledoc """
  The main module, which also defines a top-level struct to hold the state of
  the data as it is processed. This struct is passed through a pipeline of
  functions, eventually producing the required output.
  """
  alias TableBooking.{Request, Table}

  @tables Enum.map([2, 2, 2, 2, 3, 3, 4, 4, 6, 8], &%Table{capacity: &1})

  defstruct bookings: [], rejected: [], empty_tables: @tables, booked_tables: []

  def reserve(bookings) do
    bookings
    |> new()
    |> process_bookings()
    |> format_output()
  end

  defp new(bookings) do
    %__MODULE__{bookings: Request.new_list(bookings)}
  end

  defp process_bookings(state) do
    Enum.reduce(state.bookings, state, &process_booking/2)
  end

  defp process_booking(booking, state) do
    case find_suitable_table(booking, state.empty_tables) do
      :error ->
        %{state | rejected: [booking | state.rejected]}

      {:ok, table, remaining_tables} ->
        %{state | empty_tables: remaining_tables, booked_tables: [table | state.booked_tables]}
    end
  end

  defp find_suitable_table(request, tables) do
    case Enum.split_while(tables, &unsuitable?(&1, request)) do
      {_unsuitable, []} ->
        :error

      {too_small, [suitable | remainder]} ->
        {:ok, %{suitable | booked_for: request.number_of_people}, too_small ++ remainder}
    end
  end

  defp unsuitable?(table, request) do
    table.capacity < request.number_of_people or table.capacity - request.number_of_people > 1
  end

  defp format_output(state) do
    [output_successful_bookings(state), output_failed_bookings(state)]
  end

  defp output_successful_bookings(state) do
    state.booked_tables
    |> Enum.reverse()
    |> Enum.map(&Table.output/1)
  end

  defp output_failed_bookings(%{rejected: []} = _state) do
    ""
  end

  defp output_failed_bookings(state) do
    indexes_output =
      state.rejected
      |> Enum.reverse()
      |> Enum.map(& &1.index)
      |> Enum.join(", ")

    "Bookings at the following indexes were not accepted: #{indexes_output}"
  end
end
