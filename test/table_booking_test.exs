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

    test "rejects bookings when no suitable tables are left" do
      assert reserve([2, 8, 2, 8]) == [
               [
                 "table for two",
                 "table for eight",
                 "table for two"
               ],
               "Bookings at the following indexes were not accepted: 3"
             ]
    end

    test "accepts bookings that leave one empty place" do
      assert reserve([1]) == [["table for one"], ""]
    end

    test "rejects bookings that leave more than one empty place" do
      assert reserve([1, 1, 1, 1, 1]) == [["table for one", "table for one", "table for one", "table for one", ],
               "Bookings at the following indexes were not accepted: 4"
             ]
    end
  end
end
