begin
  require 'spec/rake/spectask'
rescue LoadError
  task :spec do
    $stderr.puts '`gem install rspec` to run specs'
  end
else
  desc "Run specs"
  Spec::Rake::SpecTask.new do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = %w(-fs --color)
  end
end

task :default => :spec

spec = Gem::Specification.new do |s|
  s.name     = "range_with_gaps"
  s.version  = "0.1.0"
  s.authors  = ["Timothy Elliott"]
  s.email    = ["tle@holymonkey.com"]
  s.homepage = "http://github.com/ender672/range_with_gaps"
  s.summary  = "Like Ranges, but with gaps."
  s.description = "The RangeWithGaps class lets you easily collect many ranges into one.You can perform logic operations such as union and intersection on ranges with gaps."

  s.platform = Gem::Platform::RUBY

  s.required_rubygems_version = ">= 1.3.5"

  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README.markdown)
  s.require_path = 'lib'
end

begin
  require 'rake/gempackagetask'
rescue LoadError
  task(:gem) { $stderr.puts '`gem install rake` to package gems' }
else
  Rake::GemPackageTask.new(spec) do |pkg|
    pkg.gem_spec = spec
  end
  task :gem => :gemspec
end

desc "create a gemspec file"
task :gemspec do
  File.open("#{spec.name}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end
