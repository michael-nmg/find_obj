@arr = []

def close_folder
   Dir.chdir(Dir.pwd + '/..')
end

def check_address(folder)
  Dir.pwd == '/' ? folder : "/#{folder}"
end

##################################################

# def open_folder(folder)
#  dir = Dir.pwd + check_address(folder)
#  Dir.chdir(dir)
#  rescue Errno::EACCES
#    return false
#end

def open_folder(dir_folder)
  Dir.chdir(dir_folder)
  rescue Errno::EACCES
    return false
end

############################################

# def list_folders
#  Dir.entries(Dir.pwd).select{ |i| Dir.exist?(i) && i != '.' && i != '..'}.sort
#end

# def list_dir_folders
#  Dir.entries(Dir.pwd).map do |i|
#    (Dir.pwd + check_address(i)) if Dir.exist?(i) && i != '.' && i != '..'
#  end.compact.sort
#end

def list_dir_folders
  (Dir.entries(Dir.pwd) - ['.', '..']).map do |i|
    (Dir.pwd + check_address(i)) if Dir.exist?(i)
  end.compact.sort
  rescue Errno::EACCES
    return []
end

#########################################

# def include_obj?(obj)
#  Dir.entries(Dir.pwd).select{ |i| i.include?(obj) }
#end

# def include_obj?(obj)
#  Dir.entries(Dir.pwd).select{ |i| i.downcase.include?(obj) }
#end

def include_obj?(obj)
  Dir.entries(Dir.pwd).select{ |i| i.downcase.include?(obj) }
  rescue Errno::EACCES
    return []
end

#########################################

def add_adress(arr)
  arr.each{ |name| @arr.push(Dir.pwd + check_address(name)) }
end

def add_adress(arr, dir)
  arr.each{ |name| @arr.push(dir + check_address(name)) }
end

#############################################

# def check_way(folder)
#  dir = Dir.pwd + check_address(folder)
#  @passed_way.include?(dir) ? true : @passed_way.push(dir)
#end

def check_way(dir)
  @passed_way.include?(dir) ? true : @passed_way.push(dir)
end

#############################################

# def search_function(obj)
#  res = include_obj?(obj)
#  list = list_folders
#
#  add_adress(res) if res.any?
#
#  list.each do |folder|
#    #print "#{list}\n"
#    unless open_folder(folder) == false
#      search_function(obj)
#      close_folder
#    end unless check_way(folder) == true
#  end if list.any?
#end


# def search_function(obj)
#  res = include_obj?(obj)
#  list = list_dir_folders
#
#  add_adress(res) if res.any?
#
#  list.each do |dir|
#    unless open_folder(dir) == false
#      search_function(obj)
#      close_folder
#    end unless check_way(dir) == true
#  end if list.any?
#end

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

#####################################

def search_function(obj)
  list = list_dir_folders
  list.each do |dir|
    unless open_folder(dir) == false
      search_function(obj)
      close_folder
    end unless check_way(dir) == true
  end if list.any?
end


def xxx(obj)
  thread = []
  @passed_way.each do |dir|
    thread.push Thread.new(dir) {
    res = Dir.entries(dir).select{ |i| i.downcase.include?(obj) }
    res.each{ |name| @arr.push(dir + check_address(name)) } if res.any?
    }
  end
  thread.each(&:join)
end
#########################################

@passed_way = []
@passed_way.push(Dir.pwd + check_address(folder))

@all_objects += (Dir.entries(Dir.pwd) - ['.', '..'])
@all_folders += list.count

##########################################################

Thread.new

Dir.chdir("/home/michael-nmg/.rvm")

@arr = []
@passed_way = []
start = Time.now
search_function("root")
Time.now - start
@arr.count
@arr.uniq.count
@passed_way.count
@passed_way.uniq.count


@passed_way.each{|i| puts i}



###################### compile #################################

class Search

  attr_accessor :arr, :passed_way, :directory

  def initialize(directory)
    @arr = []
    @passed_way = []
    @directory = directory
    Dir.chdir(directory)
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

  private

  def close_folder
     Dir.chdir(Dir.pwd + '/..')
  end

  def check_address(folder)
    Dir.pwd == '/' ? "#{folder}" : "/#{folder}"
  end

  def open_folder(dir_folder)
    Dir.chdir(dir_folder)
    rescue Errno::EACCES
      return false
  end

  def list_dir_folders
    (Dir.entries(Dir.pwd) - ['.', '..']).map do |i|
      (Dir.pwd + check_address(i)) if Dir.exist?(i)
    end.compact.sort
    rescue Errno::EACCES
      return []
  end

  def include_obj?(obj)
    Dir.entries(Dir.pwd).select{ |i| i.downcase.include?(obj) }
    rescue Errno::EACCES
      return []
  end

  def add_adress(arr)
    arr.each{ |name| @arr.push(Dir.pwd + check_address(name))}
  end

  def check_way(dir)
    @passed_way.include?(dir) ? true : @passed_way.push(dir)
  end

end
