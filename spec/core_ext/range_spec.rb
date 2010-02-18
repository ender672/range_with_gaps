require 'range_with_gaps/core_ext/range'
require File.expand_path('../../spec_helper', __FILE__)

describe "core extension to Range" do
  it "left trims ranges on subtraction" do
    r = (3..5) - (3..4)
    r.should == (5..5)

    r = (3...6) - (3...5)
    r.should == (5...6)
  end

  it "right trims ranges on subtraction" do
    r = (3..5) - (4..5)
    r.should == (3...4)

    r = (3...6) - (4...6)
    r.should == (3...4)
  end

  it "knows when ranges are adjacent to each other" do
    r = (4...7)
    r.adjacent?(7..7).should be_true
    r.adjacent?(6..7).should be_false

    r = (4..7)
    r.adjacent?(8..9).should be_true
    r.adjacent?(7..24).should be_false
  end

  it "does unions" do
    ((4..7) | (7..9)).should == (4..9)
    ((20...22) | (22..22)).should == (20..22)
    ((22..22) | (20...22)).should == (20..22)
  end

  it "splits ranges on subtraction" do
    r = (3..5) - (4..4)
    r.should == [(3...4), (5..5)]

    r = (3...6) - (4...5)
    r.should == [(3...4), (5...6)]
  end

  it "returns nil for empty ranges on subtraction" do
    r = (3..5) - (2..6)
    r.should be_nil

    r = (3..5) - (3...6)
    r.should be_nil

    r = (3...6) - (3...6)
    r.should be_nil
  end

  it "calculates range sizes" do
    (3..5).size.should == 3
    (3...5).size.should == 2
    (5..5).size.should == 1
    (5...5).size.should == 0
  end

  it "intersects" do
    (1..5).send(:&, 1..5).should == (1..5)
    (1..5).send(:&, 1...5).should == (1...5)
    (1..5).send(:&, 4..5000).should == (4..5)
    (1..5).send(:&, 6..23).should be_nil
  end
end

