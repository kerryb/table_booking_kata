defmodule TableBooking.Request do
  @enforce_keys [:number_of_people, :index]
  defstruct [:number_of_people, :index]

  def new_list(requests) do
    requests
    |> Enum.with_index()
    |> Enum.map(fn {request, index} -> %__MODULE__{number_of_people: request, index: index} end)
  end
end

defmodule TableBooking.Table do
  @numbers_as_words %{
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight"
  }

  @enforce_keys :capacity
  defstruct capacity: nil, booked_for: nil

  def output(table) do
    "table for #{@numbers_as_words[table.booked_for]}"
  end
end

defmodule TableBooking do
  alias TableBooking.{Request, Table}

  @tables Enum.map([2, 2, 2, 2, 3, 3, 4, 4, 6, 8], &%Table{capacity: &1})

  defstruct requested_bookings: [],
            unaccepted_bookings: [],
            empty_tables: @tables,
            booked_tables: []

  def reserve(bookings) do
    bookings
    |> new()
    |> process_requested_bookings()
    |> format_output()
  end

  defp new(bookings) do
    %__MODULE__{requested_bookings: Request.new_list(bookings)}
  end

  defp process_requested_bookings(%{requested_bookings: []} = bookings) do
    bookings
  end

  defp process_requested_bookings(
         %{requested_bookings: [request | remaining_requests]} = bookings
       ) do
    bookings =
      case find_suitable_table(request, bookings.empty_tables) do
        :error ->
          %{
            bookings
            | requested_bookings: remaining_requests,
              unaccepted_bookings: [request | bookings.unaccepted_bookings]
          }

        {:ok, table, remaining_tables} ->
          %{
            bookings
            | requested_bookings: remaining_requests,
              empty_tables: remaining_tables,
              booked_tables: [table | bookings.booked_tables]
          }
      end

    process_requested_bookings(bookings)
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

  defp format_output(bookings) do
    [output_successful_bookings(bookings), output_failed_bookings(bookings)]
  end

  defp output_successful_bookings(bookings) do
    bookings.booked_tables
    |> Enum.reverse()
    |> Enum.map(&Table.output/1)
  end

  defp output_failed_bookings(%{unaccepted_bookings: []} = _bookings) do
    ""
  end

  defp output_failed_bookings(bookings) do
    indexes_output =
      bookings.unaccepted_bookings
      |> Enum.reverse()
      |> Enum.map(& &1.index)
      |> Enum.join(", ")

    "Bookings at the following indexes were not accepted: #{indexes_output}"
  end
end
