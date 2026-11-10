cask "tsugite" do
  version "0.27.1"
  sha256 "8e336d06fdacc64dc454ee88c2df86339d0f14df0a1295e044ce276f959ba33d"

  url "https://github.com/justyns/tsugite/releases/download/v#{version}/Tsugite-#{version}-arm64-mac.zip"
  name "Tsugite"
  desc "Desktop app for the Tsugite agent framework"
  homepage "https://github.com/justyns/tsugite"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: ">= :ventura"

  app "Tsugite.app"

  # The release build is unsigned. Ad-hoc sign the bundle and drop the
  # quarantine flag so Gatekeeper does not block the first launch.
  postflight do
    system_command "/usr/bin/codesign",
                   args:         ["--force", "--deep", "--sign", "-", "#{appdir}/Tsugite.app"],
                   must_succeed: false
    system_command "/usr/bin/xattr",
                   args:         ["-dr", "com.apple.quarantine", "#{appdir}/Tsugite.app"],
                   must_succeed: false
  end

  uninstall quit: "io.tsugite.desktop"

  zap trash: [
    "~/Library/Application Support/Tsugite",
    "~/Library/Preferences/io.tsugite.desktop.plist",
    "~/Library/Saved Application State/io.tsugite.desktop.savedState",
  ]
end
