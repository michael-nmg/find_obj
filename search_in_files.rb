module SearchInFiles

  def search_in_files(obj)
    list_elt = list_dir_elements(sort_list())
    queue_files(list_elt[:files], obj)
    iteration_search_files( list_elt[:folders], obj )
  end

  private

  #Рекурсивная функция обхода дирректорий
  def iteration_search_files(list_up, obj)
    list_dn = list_up.reduce([]) do |acc, dir|
      if open_folder(dir) && check_history(dir)
        list_elt = list_dir_elements(sort_list())
        queue_files(list_elt[:files], obj)
        acc.concat(list_elt[:folders])
        acc
      else
        acc
      end
    end
    list_dn.size == 0 ? put_result() : iteration_search_files(list_dn, obj)
  end

  #Получает список и сигнатуру
  #Обрабатывает список файлов
  def queue_files(files, obj)
    files.each{ |path|
      res = search_in_file(path, obj)
      @res_in_file[path] = res if res.any? && !@res_in_file.has_key?(path)
    }
  end

  #Получает путь и сигнатуру
  #Окрывает содержимое файла, возвращает [] или массив совпадений внутри файла
  def search_in_file(file_path, obj)
    file = File.open(file_path, 'r')
    text = file.each_line.reduce(''){ |acc, str| acc = "#{acc} #{str.strip}" }
    file.close
    text.include?(obj) ? search_iter_in_file(text, obj, []) : []

    rescue => err
      @errs_log[file_path] = "#{err.class}: #{err.message}"
      return []
  end

  #Получает содержимое, сигнатуру, пустой массив
  #Возвращает список [] совпадений внутри файла
  def search_iter_in_file(text, obj, res)
    point = text =~ /#{obj}/
    word = point + obj.length - 1
    res.push( fragment(text, point, word, 15) )
    new_text = text[(word + 1)..-1]
    new_text.include?(obj) ? search_iter_in_file(new_text, obj, res) : res
  end

  #Получает содержимое, точки начала и конца слова, длину фрагмента
  #Возвращает фрагмент текста с совпадением
  def fragment(text, point, word, n = 20)
    n = n > text.length ? n - text.length : n
    if (point - n <= 0)
      "#{text[0..(point - 1)]}#{text[point..word].upcase}#{text[(word + 1)..(word + n + 1)]}..."
    elsif (word + n + 1 >= text.length)
      "...#{text[(point - n)..(point - 1)]}#{text[point..word].upcase}#{text[(word + 1)..-1]}"
    else
      "...#{text[(point - n)..(point - 1)]}#{text[point..word].upcase}#{text[(word + 1)..(word + n + 1)]}..."
    end
  end
end
