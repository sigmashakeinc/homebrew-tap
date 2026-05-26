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
  version "0.29.124"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.124/ssg-darwin-arm64.tar.gz"
      sha256 "60c1b8183bf2e3035f4ee72f8f11fe0c763d4f036147ba90765d696e13cdd21f"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.124/ssg-darwin-x64.tar.gz"
      sha256 "c7ebdb2e0bef55579692b516cb7443923223f8249bf5e7103ae443ffa5a4c91a"
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.124/ssg-linux-arm64.tar.gz"
      sha256 "70cf7b0b434dd9230d463a7fadf8a0d29a09396b6af7ac7c3ad7ef13f05d1730"
    else
      url "https://github.com/sigmashakeinc/ssg/releases/download/v0.29.124/ssg-linux-x64.tar.gz"
      sha256 "5fe714abdc0a48868f79169eb7ef31fe23b03da5b3067fc88e25cf708740e683"
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
