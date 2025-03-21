class Hping < Formula
  desc "Command-line oriented TCP/IP packet assembler/analyzer"
  homepage "http://www.hping.org/"
  url "http://www.hping.org/hping3-20051105.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/hping-3.20051105.tar.gz"
  version "3.20051105"
  sha256 "f5a671a62a11dc8114fa98eade19542ed1c3aa3c832b0e572ca0eb1a5a4faee8"

  # The first-party download page (http://www.hping.org/download.php) has
  # removed links to any archive files, with a notice that Hping is no longer
  # actively developed. There won't be any new releases and we can't check for
  # any in this state, so it's appropriate to skip this. If the GitHub repo
  # (https://github.com/antirez/hping) starts creating releases, then it would
  # be appropriate to update this livecheckable but there are no releases at
  # the time of writing this.
  livecheck do
    skip "No longer actively developed"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93622fae40adc4978f6578951ac5c7695701733abba5e543e2205355043df0f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "0dc61d108f8af1261dc84674f8840bb079f1e51fdbfb50dca5284d522049e5a8"
    sha256 cellar: :any_skip_relocation, catalina:      "3cf96bb2d2dcc407aadab3bb2691937e2adc96008df65314b889914621ade865"
    sha256 cellar: :any_skip_relocation, mojave:        "dd0b27a1e3b858378a184dd2cca506bbed420d103a75bb98545a649890142ab9"
    sha256 cellar: :any_skip_relocation, high_sierra:   "088413e9a62fe7b67627f41b91d762c2b639ca6b5598175002616ceb234fe93a"
    sha256 cellar: :any_skip_relocation, sierra:        "e6b7a8ef4527b282da33e75fc9484dee752f365b34498849fd251146948f0e80"
    sha256 cellar: :any_skip_relocation, el_capitan:    "9644e041cb830ebd121c224cef3727e20c5bf4dcca918fd91135d74e10eb2123"
    sha256 cellar: :any_skip_relocation, yosemite:      "95f5fabc90cdd2e8ca9b10189f69a2057019b35ac1f6cb2e7e4afa7bea1221d5"
  end

  patch :DATA

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fc1d446f/hping/patch-libpcap_stuff.c.diff"
    sha256 "56d3af80a6385bf93257080233e971726283d6555cc244ebe886ea21133e83ad"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fc1d446f/hping/patch-ars.c.diff"
    sha256 "02138051414e48b9f057a2dd8134c01ccd374aff65593833a799a5aaa36193c4"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fc1d446f/hping/patch-sendip.c.diff"
    sha256 "e7befff6dd546cdb38b59d9e6d3ef4a4dc09c79af2982f4609b2ea5dadf1a360"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fc1d446f/hping/patch-Makefile.in.diff"
    sha256 "18ceb30104bdb906b540bb5f6316678ce85fb55f5c086d2d74417416de3792f8"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fc1d446f/hping/patch-bytesex.h.diff"
    sha256 "7bad5e8b4b5441f72f85d50fa3461857a398b87e2d0cb63bb30985c9457be21d"
  end

  def install
    # Compile fails with tcl support; TCL on macOS is 32-bit only
    system "./configure", "--no-tcl"

    # Target folders need to exist before installing
    sbin.mkpath
    man8.mkpath
    system "make", "CC=#{ENV.cc}",
                   "COMPILE_TIME=#{ENV.cflags}",
                   "INSTALL_PATH=#{prefix}",
                   "INSTALL_MANPATH=#{man}",
                   "install"
  end
end

__END__
diff --git a/gethostname.c b/gethostname.c
index 3d0ea58..a8a9699 100644
--- a/gethostname.c
+++ b/gethostname.c
@@ -18,8 +18,6 @@
 #include <arpa/inet.h>
 #include <string.h>

-size_t strlcpy(char *dst, const char *src, size_t siz);
-
 char *get_hostname(char* addr)
 {
 	static char answer[1024];
