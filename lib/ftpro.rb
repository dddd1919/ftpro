require 'net/ftp'

class Ftpro < Net::FTP

  ## Net::FTP extension

  ## Function like nlst and also show hide files
  def nlst_a(dir = nil)
    cmd = "NLST -a"
    rule_out1, rule_out2 =
      dir.nil? ? [".", ".."] : ["/.", "/.."]
    if dir
      cmd = cmd + " " + dir
    end
    files = []
    retrlines(cmd) do |line|
      files.push(line) if !line.end_with?(rule_out1, rule_out2)
    end
    return files
  end

  ## File function mirror

  ## Check if dir is a directory type
  def directory?(dir)
    current_dir = pwd
    begin
      chdir(dir)
      return true
    rescue
      return false
    ensure
      chdir(current_dir) ## Go back former dir
    end
  end

  ## Check if file_path is a file type
  def file?(file_path)
    nlst(file_path)[0] == file_path
  end

  ## Check if dir exist
  def exist?(dir)
    return true if !nlst(dir).empty? ## File or not empty directory
    ## Check if a empty directory
    directory?(dir)
  end

  ## FileUtils function mirror
  def mkdir_p(new_dir)
    dir_parts = new_dir.split("/")
    dir_parts.length.times do |i|
      current_dir = dir_parts[0..i].join("/")
      mkdir(current_dir) unless exist?(current_dir)
    end
    return new_dir if exist?(new_dir)
  end

  ## Upload local directory to ftp server with local directory name
  def put_r(local_dir, remote_dir)
    return false if !File.directory?(local_dir)
    upload_dir(local_dir, remote_dir)
  end

  def rm_r(dir)
    dir_files = scan_ftp_dir(dir)
    ## empty fodler by the reverse of scan result
    (dir_files.length - 1).downto(0) do |f|
      if file?(dir_files[f])
        delete(dir_files[f])
      else
        rmdir(dir_files[f])
      end
    end
  end

  private

    def scan_ftp_dir(dir, scan_list = [])
      return [] if !exist?(dir)
      scan_list.concat([dir])
      nlst_a(dir).each do |sub_file|
        if file?(sub_file)
          scan_list.concat([sub_file])
        else
          scan_ftp_dir(sub_file, scan_list)
        end
      end
      return scan_list
    end

    def upload_dir(local_dir, remote_dir)
      remote_folder = local_dir.split('/')[-1] == ".." ? "" : local_dir.split('/')[-1] ## check if folder name is return symbol
      remote_new_dir = "#{remote_dir}/#{remote_folder}"
      mkdir_p(remote_new_dir)  ## init remote dir
      Dir.foreach(local_dir) do |file|
        if file != "." && file != ".."
          file_path = local_dir + "/" + file
          if File.directory?(file_path)
            upload_dir(file_path, remote_new_dir)
          else
            putbinaryfile(file_path, remote_new_dir + '/' + file)
          end
        end
      end
      return true
    end

end
