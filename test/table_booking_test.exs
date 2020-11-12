defmodule TableBookingTest do
  use ExUnit.Case
  import TableBooking

  describe "TableBooking.reserve/1" do
    test "returns an empty list of bookings and an empty unaccepted bookings string when given an empty list" do
      assert reserve([]) == [[], ""]
    end

    test "can accept a simple booking" do
      assert reserve([2]) == [["table for two"], ""]
    end
  end
end
