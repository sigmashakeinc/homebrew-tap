# Homebrew formula for ssg — AI Agent Governance CLI
# Hosted in: sigmashakeinc/homebrew-tap
# Install: brew install sigmashakeinc/tap/ssg
#
# To update this formula for a new release, run:
#   bash sigmashake-dist/homebrew/update-formula.sh
#
# Then copy the updated formula to the tap repo:
#   cp sigmashake-dist/homebrew/ssg.rb <path-to-homebrew-tap>/Formula/ssg.rb

class Ssg < Formula
  desc "AI Agent Governance CLI — evaluate tool calls against rules, block dangerous operations"
  homepage "https://sigmashake.com"
  # ssg is proprietary — sigmashake-gov/LICENSE is "All rights reserved",
  # not MIT. :cannot_represent is the documented Homebrew DSL value for
  # non-OSI-approved licenses. The tap will only ship if the formula's
  # license matches reality, and an MIT claim on a proprietary binary
  # would expose the project to license-misrepresentation risk.
  license :cannot_represent
  version "1.2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.2.0/ssg-darwin-arm64.tar.gz"
      sha256 "25dab87366df7d6ada505917eb57c4e0013031f9047de84d77c4afea4c57c2bc"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.2.0/ssg-darwin-x64.tar.gz"
      sha256 "0e7803b6a49e2c2252ea7905bc9ddefc61ac2927f0ff6ccc4db458a84e91e318"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.2.0/ssg-linux-arm64.tar.gz"
      sha256 "1c3764f15580d376f9006bcf897b0e18b4aaa31bbdae7f2673a9617dbe6c6d4a"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.2.0/ssg-linux-x64.tar.gz"
      sha256 "a1cf1c4dd718466f4aa4439a7c06bad572c6ee45bfc86fce19f6526e46b8292c"
    end
  end

  def install
    bin.install "ssg"
    # The dashboard SPA must sit at <execDir>/public/ so ssg serve's
    # publicDir resolver (candidate #3 in src/commands/serve.ts) finds it.
    # Without this, `ssg serve` renders a "Dashboard client not built"
    # placeholder. Matches the install.sh + Electrobun bundle layout.
    if File.directory?("public")
      (bin/"public").mkpath
      cp_r Dir["public/*"], bin/"public"
    end
  end

  test do
    output = shell_output("#{bin}/ssg --version 2>&1")
    assert_match version.to_s, output
  end
end
