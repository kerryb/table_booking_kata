defmodule TableBooking.Table do
  @numbers_as_words %{ 1 => "one", 2 => "two", 3 => "three", 4 => "four", 5 => "five", 6 => "six", 7 => "seven", 8 => "eight", }

  @enforce_keys :capacity
  defstruct capacity: nil, booked_for: nil

  def output(table) do
    "table for #{@numbers_as_words[table.booked_for]}"
  end
end

defmodule TableBooking do
  alias TableBooking.Table

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
    %__MODULE__{requested_bookings: Enum.sort(bookings, :desc)}
  end

  defp process_requested_bookings(%{requested_bookings: []} = bookings) do
    bookings
  end

  defp process_requested_bookings(
         %{
           requested_bookings: [request | remaining_requests],
           empty_tables: [table | remaining_tables],
           booked_tables: booked_tables
         } = bookings
       ) do
    process_requested_bookings(%{
      bookings
      | requested_bookings: remaining_requests,
        empty_tables: remaining_tables,
        booked_tables: [%{table | booked_for: request} | booked_tables]
    })
  end

  defp format_output(bookings) do
    [output_successful_bookings(bookings), output_failed_bookings(bookings)]
  end

  defp output_successful_bookings(bookings) do
    Enum.map(bookings.booked_tables, &Table.output/1)
  end

  defp output_failed_bookings(_bookings) do
    ""
  end
end
