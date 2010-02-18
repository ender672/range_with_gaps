require 'range_with_gaps'
require 'spec_helper'
require 'date'

describe "Range With Gaps" do
  it "combines multiple ranges" do
    r = RangeWithGaps.new(3..19, 90..114, 7..40, 3000..3000, 50...77)
    r.should == RangeWithGaps.new(3..40, 50...77, 90..114, 3000..3000)
  end

  it "subtracts a simple range" do
    r = RangeWithGaps.new(3..5)
    r.delete(3..4)

    r.should == RangeWithGaps.new(5..5)
  end

  it "subtracts complex ranges" do
    r = RangeWithGaps.new(3..19, 90..114, 7..40, 3000..3000, 50...77)
    r2 = RangeWithGaps.new(3..3000)

    r2.delete r
    r2.should == RangeWithGaps.new(41...50, 77...90, 115...3000)
  end

  it "gives the size of a range set" do
    r = RangeWithGaps.new(3..19, 40...43, 50..50, 56...57, 99...99)
    r.size.should == 22
  end

  it "works with dates" do
    r = RangeWithGaps.new((Date.today - 300)..Date.today)
    r.add((Date.today + 40)..(Date.today + 100))

    r.include?(Date.today - 20).should be_true
    r.include?(Date.today + 20).should be_false
  end

  it "works with floats" do
    r = RangeWithGaps.new(12.4...14.1, 33.0..53.9)

    r.delete(35.2..99.9)
    r.include?(35.2).should be_false
    r.include?(35.1999).should be_true

    r.delete(14.1)
    r.include?(14.1).should be_false

    r << (14.1..33.0)
    r.include?(14.1).should be_true
    r.should == RangeWithGaps.new(12.4...14.1, 14.1...35.2)
  end

  it "dups" do
    r = RangeWithGaps.new 1..4
    r2 = RangeWithGaps.new 6..15
    r3 = r + r2

    r.include?(7).should be_false
    r2.include?(3).should be_false
  end

  it "intersects" do
    r = RangeWithGaps.new 1..5, 8..18
    r2 = RangeWithGaps.new 2...5, 9..3000, 3002...400000

    r3 = r & r2
    r3.should == RangeWithGaps.new(2...5, 9..18)
  end

  it "converts single values and enums" do
    r = RangeWithGaps.new 1..5, 8..18

    r.add 6
    r.should == RangeWithGaps.new(1..6, 8..18)

    r.add 200
    r.should == RangeWithGaps.new(1..6, 8..18, 200..200)

    r.add [40, 41, 42, 44, 55..70]
    r.should == RangeWithGaps.new(1..6, 8..18, 40..42, 44..44, 55..70, 200..200)

    r << (20...22)
    r << 22
    r.should == RangeWithGaps.new(1..6, 8..18, 20..22, 40..42, 44..44, 55..70, 200..200)
  end
end
