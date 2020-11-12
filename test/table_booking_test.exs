defmodule TableBookingTest do
  use ExUnit.Case
  import TableBooking

  describe "TableBooking.reserve/1" do
    test "returns an empty list of bookings and an empty unaccepted bookings string when given an empty list" do
      assert reserve([]) == [[], ""]
    end

    test "accepts a single booking" do
      assert reserve([2]) == [["table for two"], ""]
    end

    test "accepts bookings that exactly match the capacity" do
      assert reserve([2, 2, 2, 2, 3, 3, 4, 4, 6, 8]) == [
               [
                 "table for two",
                 "table for two",
                 "table for two",
                 "table for two",
                 "table for three",
                 "table for three",
                 "table for four",
                 "table for four",
                 "table for six",
                 "table for eight"
               ],
               ""
             ]
    end
  end
end
