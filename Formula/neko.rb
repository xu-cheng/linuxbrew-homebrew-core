class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "https://nekovm.org/"
  url "https://github.com/HaxeFoundation/neko/archive/v2-3-0/neko-2.3.0.tar.gz"
  sha256 "850e7e317bdaf24ed652efeff89c1cb21380ca19f20e68a296c84f6bad4ee995"
  revision 1
  head "https://github.com/HaxeFoundation/neko.git"

  bottle do
    cellar :any
    sha256 "aedc2d1e4ac68af356e4d3d6e1bde0553b737e5734a227dfe2134645d363b788" => :catalina
    sha256 "7a499e2421564e1b752f658ffd8af89cbd91dd4418fa6b68390a7f55652f7420" => :mojave
    sha256 "29be87f25d471ad2961b3bcd526eaccd618fa050cab5d3c6e29aaa2953df1178" => :high_sierra
    sha256 "cb9bd66140c76edcba48df3960f000692c6b195efa1c1fd29dec12e9aabea6d0" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "mbedtls"
  depends_on "openssl@1.1"
  depends_on "pcre"
  unless OS.mac?
    depends_on "apr"
    depends_on "apr-util"
    depends_on "httpd"
    # On mac, neko uses carbon. On Linux it uses gtk2
    depends_on "gtk+"
    depends_on "pango"
    depends_on "sqlite"
  end

  def install
    args = std_cmake_args
    unless OS.mac?
      args << "-DAPR_LIBRARY=#{Formula["apr"].libexec}/lib"
      args << "-DAPR_INCLUDE_DIR=#{Formula["apr"].libexec}/include/apr-1"
      args << "-DAPRUTIL_LIBRARY=#{Formula["apr-util"].libexec}/lib"
      args << "-DAPRUTIL_INCLUDE_DIR=#{Formula["apr-util"].libexec}/include/apr-1"
    end

    # Let cmake download its own copy of MariaDBConnector during build and statically link it.
    # It is because there is no easy way to define we just need any one of mariadb, mariadb-connector-c,
    # mysql, and mysql-connector-c.
    system "cmake", ".", "-G", "Ninja", "-DSTATIC_DEPS=MariaDBConnector",
           "-DRELOCATABLE=OFF", "-DRUN_LDCONFIG=OFF", *args
    system "ninja", "install"
  end

  def caveats
    s = ""
    if HOMEBREW_PREFIX.to_s != "/usr/local"
      s << <<~EOS
        You must add the following line to your .bashrc or equivalent:
          export NEKOPATH="#{HOMEBREW_PREFIX}/lib/neko"
      EOS
    end
    s
  end

  test do
    ENV["NEKOPATH"] = "#{HOMEBREW_PREFIX}/lib/neko"
    system "#{bin}/neko", "-version"
  end
end
