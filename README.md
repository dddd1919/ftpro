# Ftpro overview

Ftpro is a extension class of Net::FTP that provide more function to handle Ftp

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ftpro'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ftpro

## Usage

This gem provide a ruby class `Ftpro`, you can use it like `Net::FTP`:


```ruby
  Ftpro.open('ftp.netlab.co.jp') do |ftp|
    ftp.login
    files = ftp.chdir('pub/lang/ruby/contrib')
    files = ftp.list('n*')
    ftp.getbinaryfile('nif.rb-0.91.gz', 'nif.gz', 1024)
  end
```

Or

```ruby
  ftp = Net::FTP.new('ftp.netlab.co.jp')
  ftp.login
  files = ftp.chdir('pub/lang/ruby/contrib')
  files = ftp.list('n*')
  ftp.getbinaryfile('nif.rb-0.91.gz', 'nif.gz', 1024)
  ftp.close
```

`Ftpro` add some function that draw lessons from `File` and `FileUtils` class, some example to show these:

```ruby
  ftp = Net::FTP.new('ftp.netlab.co.jp')
  ftp.login

  ## Function like ftp.nlst and also show hidden file in it.
  ftp.nlst_a(some_directory)

  ## Show if DIR on ftp server is a directory
  ftp.directory?(DIR)

  ## Show if FILE on ftp server is a file
  ftp.file?(FILE)

  ## Check if DIR is exist on ftp server, DIR can be a file or directory
  ftp.exist?(DIR)

  ## Function like FileUtils#mkdir_p on ftp server
  ftp.mkdir_p(REMOTE-DIR)

  ## Upload local directory and sub directory to remote dir on ftp server, directory will be create if remote dir not exist
  ftp.put_r(local_dir, remote_dir)

  ## Function like FileUtils#rm_r on ftp server
  ftp.rm_r(dir)
  
  ftp.close

```

## Contributing

1. Fork it ( https://github.com/dddd1919/ftpro/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
