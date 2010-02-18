class RangeWithGaps
  module RangeMath
    # From Ruby Facets. Returns true if this range overlaps with another range.
    def overlap?(enum)
      include?(enum.first) or enum.include?(first)
    end

    # Returns true if this range completely covers the given range.
    def mask?(enum)
      higher_or_equal_rhs_as?(enum) && include?(enum.first)
    end

    # Returns a new range containing all elements that are common to both.
    def &(enum)
      enum.is_a?(Enumerable) or raise ArgumentError, "value must be enumerable"
      return nil unless overlap?(enum)

      first_val = [first, enum.first].max
      hi = lower_or_equal_rhs_as?(enum) ? self : enum

      self.class.new first_val, hi.last, hi.exclude_end?
    end

    # Returns a new range built by merging self and the given range. If they are
    # non-overlapping then we return an array of ranges.
    def |(enum)
      if overlap?(enum) || adjacent?(enum)
        first_val = [first, enum.first].min
        hi = higher_or_equal_rhs_as?(enum) ? self : enum

        self.class.new first_val, hi.last, hi.exclude_end?
      else
        return self, enum
      end
    end

    # Return true if this range and the other range are adjacent to each other.
    # Non-sequential ranges that exclude an end can not be adjacent.
    def adjacent?(enum)
      adjacent_before?(enum) || enum.adjacent_before?(self)
    end

    # Returns a new range by subtracting the given range from self. If all
    # elements are removed then returns nil. If the subtracting range results
    # in a split of self then we return two ranges in a sorted array. Only works
    # on ranges that represent a sequence of values and respond to succ.
    def -(enum)
      return self.dup unless overlap?(enum)

      if enum.mask?(self)
        nil
      elsif first >= enum.first
        ltrim enum
      elsif lower_or_equal_rhs_as?(enum)
        rtrim enum
      else
        [rtrim(enum), ltrim(enum)]
      end
    end

    # Return the physical dimension of the range. Only works with ranges that
    # represent a sequence. This can be confusing for ranges of floats, since
    # (0.0..42.0) will result in the same size as (0.0...42.0). Won't work with
    # ranges that don't support the minus operator.
    def size
      (sequential? ? one_after_max : last) - first
    end

    # Returns true if this range has nothing. This only happens with ranges such
    # as (0...0)
    def empty?
      last == first && exclude_end?
    end

    private

    # Uses the given enumerable to left trim this range
    def ltrim(enum)
      first_val = sequential? ? enum.one_after_max : enum.last
      self.class.new first_val, last, exclude_end?
    end

    # Uses the given enumerable to right trim this range
    def rtrim(enum)
      self.class.new first, enum.first, true
    end

    # Return true if this range is sequential and its elements respond to succ.
    def sequential?
      first.respond_to?(:succ)
    end

    # Return true if this range has a higher or equal rhs as the given range
    def higher_or_equal_rhs_as?(enum)
      last > enum.last || (last == enum.last && (!exclude_end? || enum.exclude_end?))
    end

    # Return true if this range has a lower or equal rhs as the given range
    def lower_or_equal_rhs_as?(enum)
      last < enum.last || (last == enum.last && (exclude_end? || !enum.exclude_end?))
    end

    protected

    # Return the value that is one after the max value. This allows us to compare
    # ranges with our without exclude_end? set to true.
    def one_after_max
      exclude_end? ? last : last.succ
    end

    def adjacent_before?(enum)
      if sequential?
        one_after_max == enum.first
      else
        last == enum.first && !exclude_end?
      end
    end
  end
end
