Dir.chdir '/home/micahel-nmg/Projects'

class Search
  attr_reader :find_obj

  # function: enter name for search
  def self.enter_object
    print 'Enter find object: '
    @find_obj = gets.strip
  end

  def self.open_folder(folder)
    if Dir.pwd != '/'
      Dir.chdir(Dir.pwd + "/#{folder}")
    else
      Dir.chdir(Dir.pwd + "#{folder}/")
    end
  rescue Errno::EACCES
    return false
  end

  def self.close_folder
    Dir.chdir(Dir.pwd + '/..')
  end

  def self.folders_content
    arr = Dir.entries(Dir.pwd)
    arr.delete('.')
    arr.delete('..')
    arr.delete_if do |i|
      Dir.exist?(i) == false
    end
    return false if arr.count == 0
    arr
    rescue Errno::EACCES
      return false
  end

  def self.include_obj?
    Dir.entries(Dir.pwd).each do |i|
      return true if i.include?(@find_obj)
    end
    return false
    rescue Errno::EACCES
      return false
  end

  def self.add_adress
    Dir.entries(Dir.pwd).each_with_index do |i, k|
      if i.include?(@find_obj)
        print "File is found: > #{Dir.pwd}/#{Dir.entries(Dir.pwd)[k]}\n"
      end
    end
  end

  def self.status_bar
    if Dir.pwd.length <= 90
      print Dir.pwd
      print "\r" + ' ' * Dir.pwd.length + "\r"
    end
  end

  def self.search(folders)
    add_adress
    folders.each do |i|
      if open_folder(i)
        if folders_content == false && include_obj? == true
          add_adress
          close_folder
        elsif folders_content == false && include_obj? == false
          close_folder
        elsif folders_content.is_a?(Array) && include_obj? == true
          add_adress
          search(folders_content)
          close_folder
        elsif folders_content.is_a?(Array) && include_obj? == false
          search(folders_content)
          close_folder
        end
      end
    end
  end
end

Search.enter_object
Search.search(Search.folders_content)

