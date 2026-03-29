class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@docmd/core/-/core-0.6.4.tgz"
  sha256 "5032d3c984012bfc1a11bab5067f11a0594de21f916b56b01d4d8509b8c3f185"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0790ffc7f4095936cafddcf22bff7da634c943dfb3ffc3976d68ba3b0446eec2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5969b36caea7aecc128d6f1b32d093a12d18a6398fc4ecc4f13562d15f965306"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5969b36caea7aecc128d6f1b32d093a12d18a6398fc4ecc4f13562d15f965306"
    sha256 cellar: :any_skip_relocation, sonoma:        "885be3401a8cea69656942b7fc507c6d2d1fe64085106f0de6d4c467a84b8781"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b91d5a685e1446bf308414e3feea02764ec779ae388c58571b02a813a9eebf59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b91d5a685e1446bf308414e3feea02764ec779ae388c58571b02a813a9eebf59"
  end

  depends_on "esbuild" # for prebuilt binaries
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@docmd/core/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove pre-built binaries
    rm_r(libexec/"lib/node_modules/@docmd/core/node_modules/@esbuild")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"docmd.config.js"
    assert_match 'title: "Welcome"', (testpath/"docs/index.md").read
  end
end
