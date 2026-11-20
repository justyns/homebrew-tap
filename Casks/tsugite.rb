cask "tsugite" do
  version "0.29.0"
  sha256 "5b258cd0421ed4234b0ad7b6794a80ed5e4cb201503b11862c8f8d2f758c4990"

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
