class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.9.6.tar.gz"
  sha256 "af8b36d5d4242ec1bd86925f0f664a610e7e94309686ef0874df6bc0867a0c3e"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b9b4604787611beb6d169395203456127a997d42720ad065ace2d50b0be6c826" => :catalina
    sha256 "56def90482cb1666c1bdb060c21f2220bb55f1458554de0e0eddc3794e2d99de" => :mojave
    sha256 "4508306571270c0998830195707b8e387c88f466a48c420d57a10a0e7258061a" => :high_sierra
    sha256 "7da1584b5254de69380f7f8d0db35a2816e6822e1a278806724e41d9ed67b104" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
    return if ENV["CI"]

    require "pty"

    %w[a b c].each { |f| (testpath/"root"/f).write("") }
    PTY.spawn("#{bin}/broot", "--cmd", ":pt", "--no-style", "--out", "#{testpath}/output.txt", testpath/"root") do |r, _w, _pid|
      r.read

      assert_match <<~EOS, (testpath/"output.txt").read.gsub(/\r\n?/, "\n")
        ├──a
        ├──b
        └──c
      EOS
    end
  end
end
