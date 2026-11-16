cask "tsugite" do
  version "0.28.0"
  sha256 "2f9b93c58621102ca162e272037c3516ad15eb2f7d0c049ced5605dba50171c5"

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
