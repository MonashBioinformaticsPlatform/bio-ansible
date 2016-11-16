#!/usr/bin/env ruby

require 'fileutils'
require 'json'
require "optparse"

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Create an Lmod module definition from an installed brew formula.\nUsage #{$0} [options] <formula>"

  opts.on("-m", "--module_dir DIRECTORY", "Directory to write Lmod module") do |dir|
    options[:module_dir] =  dir
  end

  options[:brew] = "brew"
  opts.on("-b", "--brew <BREW BINARY>", "Specifiy the brew binary, otherwise look in PATH") do |b|
    options[:brew] = b
  end

  opts.on("-l", "--lib <LIB DIR>", "Directory to add to LD_LIBRARY_PATH") do |b|
    options[:libdir] = b
  end
end
optparse.parse!


formula = ARGV.pop
if formula.nil?
  puts "ERROR: Missing formula"
  puts optparse
  exit(-1)
end

if options[:module_dir].nil?
  puts "ERROR: Missing module_dir"
  puts optparse
  exit(-1)
end

class FormulaInfo
  def initialize(formula, libdir,brew="brew")
    @formula=formula
    @brew=brew
    @libdir=libdir
  end

  def cellar
    return @cellar if !@cellar.nil?
    s = %x{#{@brew} config}
    @cellar = /^HOMEBREW_CELLAR: (.*?)$/m.match(s).captures[0]
  end

  def info
    return @info if !@info.nil?
    str = %x{#{@brew} info --json=v1 #{@formula}}
    @info = JSON.parse(str)
  end

  def homepage
    info.first['homepage']
  end

  def base(ver)
    "#{cellar}/#{@formula}/#{ver}"
  end
  
  def versions
    vers = info.first['installed'].map{|x| x['version']}
    vers.each do |v|
      raise "Missing version #{v}" if !File.exists?(base(v))
    end
    vers
  end

  def lmod_def(ver)
    str = <<-eos.gsub(/^\s+/, '')
      help(
      [[
      This module loads #{@formula}
      Homepage : #{homepage}
      ]])
      
      local base = "#{base(ver)}"
      local path = pathJoin(base, "bin")
      
      prepend_path("PATH", path)

      -- On load, list binaries
      if (mode() == "load" and os.getenv("LMOD_LOG")) then
        local r = capture("ls " .. path)
        LmodMessage("Loaded " .. myModuleName() .. " : " .. string.gsub(r,'\\n',' '))
      end
    eos
    if (@libdir.length>0)
      str += "prepend_path('LD_LIBRARY_PATH', pathJoin(base, '#{@libdir}'))\n"
    end
    str
  end

  def write_lmod_def(dir, ver)
    file = "#{dir}/#{@formula}/#{ver}.lua"
    if File.exist?(file)
      puts "Specification #{file} exists, skipping"
      return
    end
    puts "Writing #{file}"
    FileUtils.mkdir_p(File.dirname(file))
    File.open(file, 'w') do |file| 
      file.write(lmod_def(ver))
    end
  end

end


f = FormulaInfo.new(formula, options[:libdir], options[:brew])

f.versions.each do |v|
  f.write_lmod_def(options[:module_dir],v)
end
