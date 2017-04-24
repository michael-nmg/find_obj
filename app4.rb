class Search
  attr_accessor :search_result, :history, :start_directory, :errs_log

  def initialize(directory = Dir.pwd)
    @search_result = []
    @history = []
    @errs_log = {}
    @start_directory = directory
  end

  def search_function(obj)
    list = sort_list()
    @search_result.concat(include_obj(list, obj))
    list_dir_folders(list).each do |dir|
      if open_folder(dir) && check_history(dir)
        search_function(obj)
      end
    end
  end

  #Вывод общих сведений поиска
  def put_result()
    Dir.chdir(@start_directory)
    print "\n\n\tSearch results:\t#{@search_result.count}\n
    \tHistory:\t#{@history.count}\n
    \tErros:\t\t#{@errs_log.count}\n\n"
  end

  private

  #Сравнение адресов с историей
  def check_history(dir)
    @history.include?(dir) ? false : @history.push(dir)
  end

  #Список содержимого директории
  def sort_list()
    (Dir.entries(Dir.pwd) - ['.', '..']).sort
    rescue => err
      @errs_log[Dir.pwd] = "#{err.class}: #{err.message}"
      return []
  end

  #Выходит на уровень выше
  def close_folder
    Dir.chdir(Dir.pwd + '/..')
  end

  #Корень или нет?
  def check_address(elt)
    rest = Dir.pwd == '/' ? elt : "/#{elt}"
    Dir.pwd + rest
  end

  #Открывает папку или взвращает false
  def open_folder(dir_folder)
    Dir.chdir(dir_folder)
    rescue => err
      @errs_log[dir_folder] = "#{err.class}: #{err.message}"
      return false
  end

  #Возвращает или [] или адреса существующих директорий
  def list_dir_folders(dir_list)
    dir_list.reduce([]) do |acc, folder|
      acc.push(check_address(folder)) if Dir.exist?(folder)
      acc
    end
    rescue => err
      @errs_log[Dir.pwd] = "#{err.class}: #{err.message}"
      return []
  end

  #Возвращает или [] или адреса найденых совпадений
  def include_obj(dir_list, obj)
    dir_list.reduce([]) do |acc, elt|
      acc.push(check_address(elt)) if elt.downcase.include?(obj)
      acc
    end
    rescue => err
      @errs_log[Dir.pwd] = "#{err.class}: #{err.message}"
      return []
  end
end
