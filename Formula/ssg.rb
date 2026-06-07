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
  version "0.29.156"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.156/ssg-darwin-arm64.tar.gz"
      sha256 "e782b31df52571db0185fe7c619b9a2e4a27567ded8f62d8c7f92bf43a646b75"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.156/ssg-darwin-x64.tar.gz"
      sha256 "fa9744a309fcf6f34a4bd4d206e1e48c2a7b04c8a98bb19da0f59412f7e5e91c"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.156/ssg-linux-arm64.tar.gz"
      sha256 "c1d111de741ca8c97d543ce15664fc38ef3ee10b4b8a9ac1f52004d992ea4503"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.156/ssg-linux-x64.tar.gz"
      sha256 "ced5fe3338e3aa4c1476328844cbcd2575335e406bb4908e173e7a1d16920c0c"
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
