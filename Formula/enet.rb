class Enet < Formula
  desc "Provides a network communication layer on top of UDP"
  homepage "http://enet.bespin.org"
  url "http://enet.bespin.org/download/enet-1.3.14.tar.gz"
  sha256 "98f6f57aab0a424469619ed3047728f0d3901ce8f0dea919c11e7966d807e870"

  bottle do
    cellar :any
    sha256 "fd907590e904f76351db367069a3d28bec7ab9cb946f66a01c22102e8c9bd951" => :catalina
    sha256 "3813772ea57875407a2f949e2aaa3d9330a25e443efc231bd6aeb6b6af213001" => :mojave
    sha256 "25754aa22b0d3862dc2b0d355452c040022af50a99af5f98b39e46151aca43e1" => :high_sierra
    sha256 "d7a0e4e8189f600db8f657aa46622b20ec5dd67facf06dd370d8185ff4714b27" => :sierra
    sha256 "90b2bbf3acc1d0b043c8bdfef298e700dc1a90026c8d67e79d0fa2045a054faf" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
