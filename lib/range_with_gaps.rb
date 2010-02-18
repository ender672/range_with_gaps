require 'range_with_gaps/range_with_math'

class RangeWithGaps
  def initialize(*ranges)
    @ranges = []
    ranges.each{|r| self.add r}
  end

  def dup
    self.class.new *to_a
  end

  def ==(rset)
    @ranges == rset.instance_variable_get(:@ranges)
  end

  def add(o)
    case o
    when Range then _add(o)
    when self.class, Enumerable then o.each{|b| add b}
    else add(o..o)
    end

    return self
  end
  alias << add

  def delete(o)
    case o
    when Range then _delete(o)
    when self.class, Enumerable then o.each{|s| delete s}
    else delete(o..o)
    end

    return self
  end

  def |(enum)
    dup.add(enum)
  end
  alias + |
  alias union |

  def -(enum)
    dup.delete(enum)
  end
  alias difference -

  def &(o)
    ret = self.class.new

    case o
    when Range
      @ranges.each do |r|
        intersection = r & o
        ret.add intersection if intersection
      end
      ret
    when self.class, Enumerable
      o.each do |i|
        intersection = self & i
        ret.add intersection if intersection
      end
      ret
    else self&(o..o)
    end
  end
  alias intersection &

  def include?(elem)
    @ranges.any?{|r| r.include? elem}
  end

  def to_a
    @ranges.map{ |r| r.to_range }
  end

  def each
    to_a.each{|o| yield o}
  end

  def size
    @ranges.inject(0){|sum, n| sum + n.size}
  end

  def entries
    @ranges.map{|r| r.to_a}.flatten
  end

  def empty?
    @ranges.empty?
  end

  private

  def _add(new_range)
    new_range = RangeWithMath.from_range new_range
    return if new_range.empty?

    inserted = false

    @ranges.each_with_index do |r, i|
      if r.overlap?(new_range) || r.adjacent?(new_range)
        new_range = new_range | r
        @ranges[i] = nil
      elsif r.first > new_range.first
        @ranges.insert(i, new_range)
        inserted = true
        break
      end
    end

    @ranges << new_range unless inserted
    @ranges.compact!
  end

  def _delete(o)
    @ranges.map!{|r| r - o}
    @ranges.flatten!
    @ranges.compact!
  end
end
