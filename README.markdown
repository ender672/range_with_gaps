## Range With Gaps: A ruby class to work with discontinuous ranges

The RangeWithGaps class lets you easily collect many ranges into one. It accepts
individual values (3, 4, 5) as well as ranges (2..3000) and will fold them
together to efficiently work with them as a single set of ranges.

Once you have inserted your values and ranges, you can perform logic operations
such as union and intersection. This is particularly useful for finding
overlapping time spans.

I took care to allow for non-sequential ranges, such as ranges of floats, to
work with this class. Non-sequential ranges are ranges for data types that don't
have a succ method.

This gem adds only a single constant to the Ruby namespace; RangeWithGaps.

## Usage

In order to include the class

    require 'range_with_gaps'

Optionally, you can add math operations to the Range class:

    require 'range_with_gaps/core_ext/range'

Initialize a range with gaps, the order doesn't matter, and overlapping values
are folded together:

    range_with_gaps = RangeWithGaps.new 55...900, 1..34, 22, 23

Add values to a range with gaps:

    range_with_gaps << 0.4
    range_with_gaps.add(Time.now...(Time.now + 5000))

Delete values from a range with gaps:

    range_with_gaps.delete(Date.today - 15)
    range_with_gaps.delete(50..3000)

Fast calculation of the size of a range with gaps:

    range_with_gaps.size

Use logic operations on a range with gaps:

    # returns a range with gaps of all overlapping ranges
    range_with_gaps_one & range_with_gaps_two
    range_with_gaps & ((Date.today - 30)..Date.today)

    # returns a range with gaps of all ranges combined
    range_with_gaps_one | range_with_gaps_two

I created this class in order to simplify the calculation of billing periods in
a rails project that uses a audit table:

    require 'range_with_gaps'

    def get_premium_time_spans
      premium_time_spans = RangeWithGaps.new

      # Get all events from an audit table, i.e. every time a customer toggles
      # the premium flag on their account.
      premium_toggles = Customer.audits.premium_column

      # We only care when premium was on, so eat the first event if it was a
      # toggle to a non-premium account.
      premium_toggles.shift unless premium_toggles.first.value

      premium_toggles.each_slice(2) do |toggle_pair|
        # If we only got one element in the slice then inject a fake toggle
        # at the end of the span
        span_end = toggle_pair[1] ? toggle_pair[1].created_at : Time.now

        premium_time_spans.add(toggle_pair[0].created_at..span_end)
      end

      premium_time_spans
    end

    premium_time_spans = get_premium_time_spans

    # Calculate how long the customer had a premium account in January
    january = Time.local(2010, 1, 1)...Time.local(2010, 2, 1)
    puts "January Premium: #{(premium_time_spans & january).size} seconds"

    # Calculate how long the customer had a premium account during the two last
    # service outages
    disk_recovery = Time.local(2009, 12, 24, 15, 30)..Time.local(2009, 12, 24, 16)
    net_outage = Time.local(2010, 2, 1, 12, 15)..Time.local(2010, 2, 2, 2, 30)
    outages = RangeWithGaps.new disk_recovery, net_outage

    puts "Outage Premium: #{(premium_time_spans & outages).size} seconds"
