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
