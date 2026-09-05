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
  version "1.1.8"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.1.8/ssg-darwin-arm64.tar.gz"
      sha256 "db4dd2a42b1f8b1a91481a3f604dcf26a5a1467e667450aa447c765f4e200b28"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.1.8/ssg-darwin-x64.tar.gz"
      sha256 "1f1366c66774313715f9c96b505384d876c9a998dec6f9e8366c08af95ede343"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.1.8/ssg-linux-arm64.tar.gz"
      sha256 "be597643a69354ef32e75bf339d1df4af238a4abf4a5a7520b1b489da3e6ff0e"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v1.1.8/ssg-linux-x64.tar.gz"
      sha256 "b79317e8b32801b806a434a7bbf0da3da2e3f14b701ccf2769983c08ef141d70"
    end
  end

  def install
    bin.install "ssg"
    bin.install "ssg-hook-fast" if File.exist?("ssg-hook-fast")
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
