class GitGui < Formula
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"

  # NOTE: Please keep these values in sync with git.rb when updating.
  desc "Tcl/Tk UI for the git revision control system"
  homepage "https://git-scm.com"
  head "https://github.com/git/git.git", shallow: false

  # bottle do
  #   cellar :any_skip_relocation
  #   sha256 "710dcb76f28cd72e89b6cb03b54cc5b7ad226dd5b3c43acfb0c83e92a2ae8347" => :big_sur
  #   sha256 "8820d3ab3fb92d495faf6f3c784122f27bc8ccc4648f84812a695030f22d388c" => :catalina
  #   sha256 "42223e9dfd4b55352cdbb53b003b88b5e5f09fbf0e8e333bc903271ae7fa14b0" => :mojave
  #   sha256 "aa2b5c16d09f78e9a01f9c3b92086bd3933b36eef6e1a94e634f67966c323d9e" => :high_sierra
  # end

  depends_on "tcl-tk"

  def install
    # build verbosely
    ENV["V"] = "1"

    system "ls"
    system "rm", "-r", "git-gui"
    system "rm", "-r", "gitk-git"
    system "git", "clone", "https://github.com/prati0100/git-gui.git", "git-gui"
    system "git", "clone", "git://ozlabs.org/~paulus/gitk.git", "gitk-git"

    # By setting TKFRAMEWORK to a non-existent directory we ensure that
    # the git makefiles don't install a .app for git-gui
    # We also tell git to use the homebrew-installed wish binary from tcl-tk.
    # See https://github.com/Homebrew/homebrew-core/issues/36390
    tcl_bin = Formula["tcl-tk"].opt_bin
    args = %W[
      TKFRAMEWORK=/dev/null
      prefix=#{prefix}
      gitexecdir=#{bin}
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
      TCL_PATH=#{tcl_bin}/tclsh
      TCLTK_PATH=#{tcl_bin}/wish
    ]
    system "make", "-C", "git-gui", "install", *args
    system "make", "-C", "gitk-git", "install", *args
  end

  test do
    system bin/"git-gui", "--version"
  end
end
