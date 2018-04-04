class ScantailorUniversalQt55 < Formula
  desc "Interactive post-processing tool for scanned pages"
  homepage "https://github.com/trufanov-nok/scantailor/"
  url "https://github.com/trufanov-nok/scantailor/archive/0.2.3.tar.gz"
  sha256 "6e818f9fd0cdde5a31b7b9012deb5df167ca20097ae45a32bf114fcc1e31e0e5"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libpng"
  depends_on "qt@5.5"
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
