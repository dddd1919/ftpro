require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ftpro test" do

  let(:ftp_host) { "example.com" }
  let(:ftp_port) { "21"}
  let(:ftp_user) { 'name'}
  let(:ftp_pwd) { 'password'}

  describe "Normal function" do

    it 'With normal way' do
      ftp = Ftpro.new
      ftp.connect(ftp_host, ftp_port)
      ftp.login(ftp_user, ftp_pwd)
      expect(ftp.nlst.class).to eq(Array)
      ftp.close
    end

    it 'With block call' do
      Net::FTP::FTP_PORT = ftp_port  ## There will raise a warning cause FTP_PORT is a constant
      Ftpro.open(ftp_host) do |ftp|
        ftp.login(ftp_user, ftp_pwd)
        expect(ftp.nlst.class).to eq(Array)
      end
    end

  end

  describe "Extension function test" do

    before(:each) do
      @ftp = Ftpro.new
      @ftp.connect(ftp_host, ftp_port)
      @ftp.login(ftp_user, ftp_pwd)
    end

    after(:each) do
      @ftp.close
    end

    it 'nlst_a method test' do
      @ftp.putbinaryfile('../.gitignore')
      visible_files = @ftp.nlst
      all_files = @ftp.nlst_a
      expect(visible_files.count).to be < all_files.count
      expect(all_files - visible_files).to include('.gitignore')
      @ftp.delete('.gitignore')
    end

    it 'judge file type and exist' do
      @ftp.put_r("../spec", "")
      expect(@ftp.exist?("spec")).to be true
      expect(@ftp.directory?("spec")).to be true
      expect(@ftp.exist?("spec/ftpro_spec.rb")).to be true
      expect(@ftp.directory?("spec/ftpro_spec.rb")).to be false
      expect(@ftp.file?("spec/ftpro_spec.rb")).to be true
      @ftp.rm_r("spec")
      expect(@ftp.directory?("spec")).to be false
      expect(@ftp.exist?("spec")).to be false
    end

    it 'mkdir_p method' do
      target_dir = 'foo/bar/baz/test'
      expect(@ftp.exist?(target_dir)).to be false
      @ftp.mkdir_p(target_dir)
      expect(@ftp.exist?(target_dir)).to be true
      @ftp.rm_r("foo")
      expect(@ftp.exist?(target_dir)).to be false
    end

    it 'put_r and rm_r methods' do
      expect(@ftp.exist?('foo/bar')).to be false
      @ftp.put_r('../', 'foo/bar')
      expect(@ftp.exist?('foo/bar/lib')).to eq true
      expect(@ftp.nlst_a('foo/bar').count + 2).to eq(Dir.foreach('../').count)
      @ftp.rm_r('foo')
      expect(@ftp.exist?('foo/bar/lib')).to eq false
    end

  end

end