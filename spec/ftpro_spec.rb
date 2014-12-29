require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ftpro test" do

  before(:each) do
    @ftp_host = "example.com"
    @ftp_port = "21"
    @ftp_user = 'name'
    @ftp_pwd = 'password'
  end

  it 'With normal way' do
    ftp = Ftpro.new
    ftp.connect(@ftp_host, @ftp_port)
    ftp.login(@ftp_user, @ftp_pwd)
    expect(ftp.nlst.class).to eq(Array)
  end

  it 'With block call' do
    Net::FTP::FTP_PORT = @ftp_port  ## There will raise a warning cause FTP_PORT is a constant
    Ftpro.open(@ftp_host) do |ftp|
      ftp.login(@ftp_user, @ftp_pwd)
      expect(ftp.nlst.class).to eq(Array)
    end
  end

  it 'do some function test' do
  end

end