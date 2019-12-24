class ScantailorUniversal < Formula
  desc "Interactive post-processing tool for scanned pages"
  homepage "https://github.com/trufanov-nok/scantailor/"
  url "https://github.com/trufanov-nok/scantailor/archive/0.2.8.tar.gz"
  sha256 "d56ff329111b7ad54cd59c8a9c41f1ac5f8f506e2bd75f7b7e114498ec6b3cc5"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libpng"
  depends_on "qt"
  depends_on :x11
  
  def install
    system "cmake", ".", "-DPNG_INCLUDE_DIR=#{MacOS::X11.include}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"foo.file").write "foo"
    (testpath/"bar/foo2.file").write "foo2"
    (testpath/"bar/foo3.file").write "foo3"
    output = pipe_output("#{bin}/scantailor-cli -v --end-filter=1 foo.file bar bar")
    assert_equal <<-EOS.undent, output
    Filter: 1
    \tProcessing: #{testpath.realpath}/foo.file
    \tProcessing: #{testpath.realpath}/bar/foo2.file
    \tProcessing: #{testpath.realpath}/bar/foo3.file
    EOS
  end
end
