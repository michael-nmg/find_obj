require './search_in_files.rb'

class Search
  include SearchInFiles
  attr_accessor :errs_log, :history, :res_in_file, :search_result, :start_directory, :type

  def initialize(type = :folders)
    @errs_log = {}
    @history = []
    @res_in_file = {}
    @search_result = []
    @start_directory = Dir.pwd
    @type = type
  end

  def search_function(obj)
    @type == :folders ? search_file(obj) : self.search_in_files(obj)
  end

  #Производит поиск файлов по заданной сигнатуре
  def search_file(obj)
    list = sort_list()
    @search_result.concat( include_obj(list, obj) )
    iteration_search_dir( list_dir_elements(list)[:folders], obj )
  end

  private

  #Рекурсивная функция обхода дирректорий
  def iteration_search_dir(list_up, obj)
    list_dn = list_up.reduce([]) do |acc, dir|
      if open_folder(dir) && check_history(dir)
        list = sort_list()
        @search_result.concat( include_obj(list, obj) )
        acc.concat(list_dir_elements(list)[:folders])
        acc
      else
        acc
      end
    end
    list_dn.size == 0 ? put_result() : iteration_search_dir(list_dn, obj)
  end

  #Вывод общих сведений поиска
  def put_result()
    Dir.chdir(@start_directory)
    if @type == :folders
      print "\n\n\tSearch results:\t#{@search_result.count}\n
      \tHistory:\t#{@history.count}\n
      \tErros:\t\t#{@errs_log.count}\n\n"
    else
      print "\n\n\tConcurrence:\t#{@res_in_file.count}\n
      \tHistory:\t#{@history.count}\n
      \tErros:\t\t#{@errs_log.count}\n\n"
    end
  end

  #Полчает путь
  #Сравнение адресов с историей
  def check_history(dir)
    @history.include?(dir) ? false : @history.push(dir)
  end

  #Возвращает список содержимого директории
  def sort_list
    (Dir.entries(Dir.pwd) - ['.', '..']).sort
    rescue => err
      @errs_log[Dir.pwd] = "#{err.class}: #{err.message}"
      return []
  end

  #Получает элемент директории
  #Корень или нет?
  def check_address(elt)
    rest = Dir.pwd == '/' ? elt : "/#{elt}"
    Dir.pwd + rest
  end

  #Получает путь
  #Открывает папку или возвращает false
  def open_folder(dir_folder)
    Dir.chdir(dir_folder)
    rescue => err
      @errs_log[dir_folder] = "#{err.class}: #{err.message}"
      return false
  end

  #Получает список содержимого папки
  #Возвращает: {} или {пути :folders и :files}
  def list_dir_elements(dir_list)
    dir_list.reduce({folders: [], files: []}) do |acc, elt|
      if Dir.exist?(elt)
        acc[:folders].push(check_address(elt))
      else
        acc[:files].push(check_address(elt))
      end
      acc
    end

    rescue => err
      @errs_log[Dir.pwd] = "#{err.class}: #{err.message}"
      return {folders: [], files: []}
  end

  #Получает список объектов директории и сигнатуру
  #Возвращает [] или адреса найденых совпадений
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
