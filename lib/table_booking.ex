defmodule TableBooking.Table do
  @enforce_keys :capacity
  defstruct capacity: nil, booked?: false, booked_for: nil
end

defmodule TableBooking do
  alias TableBooking.Table

  @tables Enum.map([8, 6, 4, 4, 3, 3, 2, 2, 2, 2], &%Table{capacity: &1})

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

  defp new(bookings), do: %TableBooking{requested_bookings: Enum.sort(bookings, :desc)}

  defp process_requested_bookings(bookings) do
    bookings
  end

  defp format_output(_bookings) do
    [[], ""]
  end
end
