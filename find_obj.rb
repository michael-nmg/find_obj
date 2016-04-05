#encoding: utf-8

print "Enter find object: "
find_obj = gets.strip

Dir.chdir "/home/micahel-nmg/Projects"

class Search
attr_reader :find_obj, :arr

def initialize (find_obj)
  @find_obj = find_obj
end

def folders_environment
  arr = Dir.entries(Dir.pwd)
  arr.delete(".")
  arr.delete("..")
  arr.delete_if { |i|
    Dir.exist?(i) == false
  }

  return false if arr.count == 0
  arr

  rescue Errno::EACCES
    return false
end

def include_obj
  Dir.entries(Dir.pwd).each {|i|
    return true if i.include?(@find_obj)
  }

  rescue Errno::EACCES
    return false
end

def open_folder(folder)
  if Dir.pwd != "/"
    Dir.chdir(Dir.pwd + "/#{folder}")
  else
    Dir.chdir(Dir.pwd + "#{folder}/")
  end

  rescue Errno::EACCES
    return false
end

def close_folder
  Dir.chdir(Dir.pwd + "/..")
end

def add_adress
  Dir.entries(Dir.pwd).each_with_index { |i, k|
    print "File is found: > #{Dir.pwd}/#{Dir.entries(Dir.pwd)[k]}\n" if i.include?(@find_obj)
  }
end

def status_bar
  if Dir.pwd.length <= 90
    print Dir.pwd
    print "\r" + " " * Dir.pwd.length + "\r" 
  end
end

def search (folders)
  add_adress
  folders.each { |i|
    if open_folder(i)
    status_bar
      if folders_environment == false && include_obj == true
        add_adress
        close_folder
      elsif folders_environment == false && include_obj == false || folders_environment == false && include_obj.is_a?(Array)
        close_folder
      elsif folders_environment.is_a?(Array) && include_obj == true
        add_adress
        search(folders_environment)
        close_folder
      elsif folders_environment.is_a?(Array) && include_obj == false || folders_environment.is_a?(Array) && include_obj.is_a?(Array)
        search(folders_environment)
        close_folder
      end
    end
  }
end

end 

s = Search.new(find_obj)
s.search(s.folders_environment)
