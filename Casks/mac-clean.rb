cask "mac-clean" do
  version "1.3.4"
  sha256 "f5a21165ab8b2ac34919cf3c424b3622f06d7e3c60ae542a88c8ef660dda5995"

  url "https://github.com/iliyami/MacClean/releases/download/v#{version}/MacClean-#{version}.dmg",
      verified: "github.com/iliyami/MacClean/"
  name "Mac Clean"
  desc "Open-source Mac cleaner, optimizer, and malware scanner"
  homepage "https://github.com/iliyami/MacClean"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "Mac Clean.app"

  postflight do
    # Mac Clean is open source and not notarized — we don't pay Apple's $99/year
    # gatekeeping tax. Remove the quarantine flag so the app launches cleanly.
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Mac Clean.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Application Support/Mac Clean",
    "~/Library/Caches/com.macclean.app",
    "~/Library/Logs/MacClean",
    "~/Library/Preferences/com.macclean.app.plist",
    "~/Library/Saved Application State/com.macclean.app.savedState",
  ]

  caveats <<~EOS
    Mac Clean is open source and intentionally not notarized — we don't pay
    Apple's $99/year gatekeeping tax to ship free software.

    This cask automatically removes the quarantine flag during install, so the
    app should launch normally. If you ever see a Gatekeeper warning, run:

      sudo xattr -dr com.apple.quarantine "/Applications/Mac Clean.app"

    Some features (Mail, Safari, Privacy scans) require Full Disk Access:
      System Settings → Privacy & Security → Full Disk Access
  EOS
end
