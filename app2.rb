def return_to_prime_dir
   Dir.chdir(@dir)
end

def open_folder(dir_folder)
  Dir.chdir(dir_folder)
  rescue Errno::EACCES
    return false
end


def check_address(folder, dir)
  dir == '/' ? folder : "/#{folder}"
end

def list_dir_folders(dir)
  open_folder(dir)
  (Dir.entries(dir) - ['.', '..']).map do |i|
    (dir + check_address(i, dir)) if Dir.exist?(i)
  end.compact.sort
  rescue Errno::EACCES
    return []
end

def include_obj?(obj, dir)
  Dir.entries(dir).select{ |i| i.downcase.include?(obj) }
  rescue Errno::EACCES
    return []
end

def add_adress(arr, dir)
  arr.each{ |name| @arr.push(dir + check_address(name)) }
end

def check_way(dir)
  @passed_way.include?(dir) ? true : @passed_way.push(dir)
end



def search_function(obj)
  res = include_obj?(obj)
  list = list_dir_folders

  add_adress(res) if res.any?

  list.each do |dir|
      unless open_folder(dir) == false
        search_function(obj)
        close_folder
      end unless check_way(dir) == true
  end if list.any?
end

##############################################

Dir.chdir("/home/michael-nmg/.rvm")
@dir = "/home/michael-nmg/.rvm"
@arr = []
@passed_way = []
s = Search.new("/home/michael-nmg/.rvm" )

start = Time.now
s.search_function("root")
Time.now - start

@arr.count
@arr.uniq.count
@passed_way.count
@passed_way.uniq.count
