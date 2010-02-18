# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{range_with_gaps}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = ["Timothy Elliott"]
  s.date = %q{2010-02-18}
  s.description = %q{The RangeWithGaps class lets you easily collect many ranges into one.You can perform logic operations such as union and intersection on ranges with gaps.}
  s.email = ["tle@holymonkey.com"]
  s.files = ["lib/range_with_gaps.rb", "lib/range_with_gaps/range_with_math.rb", "lib/range_with_gaps/range_math.rb", "lib/range_with_gaps/core_ext/range.rb", "LICENSE", "README.markdown"]
  s.homepage = %q{http://github.com/ender672/range_with_gaps}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Like Ranges, but with gaps.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
