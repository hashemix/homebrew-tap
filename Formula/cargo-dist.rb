class CargoDist < Formula
  desc "The cargo-dist application"
  homepage "https://github.com/hashemix/cargo-dist"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hashemix/cargo-dist/releases/download/v0.1.0/cargo-dist-aarch64-apple-darwin.tar.gz"
      sha256 "2db2b27880444df1c99e13d528dc94a5e10121c4f1116eb31dd4674fd0b43c8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hashemix/cargo-dist/releases/download/v0.1.0/cargo-dist-x86_64-apple-darwin.tar.gz"
      sha256 "8243d22072f3e867f2918d3bdb5151829cb78d52693182a692f6fd3c757ede63"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hashemix/cargo-dist/releases/download/v0.1.0/cargo-dist-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ee43e7c94972bb0357e3f404316ed86af26a6b7eed447a59bec11c829104cabe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hashemix/cargo-dist/releases/download/v0.1.0/cargo-dist-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3aae899318f38800f5ebec59ccb9b0c414de440805883928a92a5ed5f585c560"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cargo-dist" if OS.mac? && Hardware::CPU.arm?
    bin.install "cargo-dist" if OS.mac? && Hardware::CPU.intel?
    bin.install "cargo-dist" if OS.linux? && Hardware::CPU.arm?
    bin.install "cargo-dist" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
