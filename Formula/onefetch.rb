class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v1.7.0.tar.gz"
  sha256 "b0fd4862a1f2847688ce9739eba7a28b732e6fb966086987f4276edd88aac362"

  bottle do
    cellar :any_skip_relocation
    sha256 "24b7e0e08d574596b3ecf58979250cf86929c7441a90595b4df889035409440a" => :catalina
    sha256 "74b26c65cadc88c84016d41ab1b656082a5bab933d9fee970e0e4975ed44306c" => :mojave
    sha256 "d2b3cd46a46949c0e23dedc44bace6f1532c45b1eb241c27610f55395d131060" => :high_sierra
    sha256 "a1e3d2a4579e803f3831060883ec3a368271cb8addccccb7d0ca05d9ac85d54f" => :x86_64_linux
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp
    if ENV["CI"]
      system "git config --global user.email you@example.com"
      system "git config --global user.name Name"
    end
    system "git init && echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match /Language:.*Ruby/, shell_output("#{bin}/onefetch").chomp
  end
end
