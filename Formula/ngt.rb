class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.8.1.tar.gz"
  sha256 "62b0c8a0edb6a22c8ca273b8861ce12b9529376b7e48fda94e03d017f3112f59"

  bottle do
    cellar :any
    sha256 "27cadcbb3d3e66ccff2a7ef0074e6b4aa85725066a55db97ab45e7c0cd63e66b" => :catalina
    sha256 "47e402a348d0e2d07e285af912eb7bae9ed4d12652fd1f2c92e6c9d001bf4713" => :mojave
    sha256 "a270ecb7a8203de28604e48cd95f849dc1b74b11a25b82fd2e6bc12414c21bf3" => :high_sierra
    sha256 "50aaa12267ccb74fe20682bc5872bd0ec0739108217327d973745eeecebad76a" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system "#{bin}/ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
