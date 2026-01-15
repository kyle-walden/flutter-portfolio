CI for projects/pitboard
=======================

This folder contains CI/CD examples and helper scripts used to demonstrate a realistic mobile CI setup for the `Pitboard` showcase project. All scripts are intentionally redacted of secrets.

What lives here
---------------
- `xcode-cloud/` - Example pre/post Xcode Cloud build scripts adapted (and redacted) from the original Pitboard project. These are intended to be pasted into Xcode Cloud's Pre-build and Post-build script phases or used locally for testing.
- `github-actions/` - Example GitHub Actions workflows for Android and iOS continuous-integration (CI) and release (CD) pipelines. These workflows are adapted (and redacted) from the original Pitboard project.

Files of interest
-----------------
- `xcode-cloud/ci_pre_xcodebuild.sh` - Pre-build script: installs Flutter tools, runs `flutter pub get`, runs CocoaPods install (with retry), and performs other setup steps required before `xcodebuild` runs. This script is an example only; in Xcode Cloud you should configure environment variables and secret access through the Xcode Cloud UI.
- `xcode-cloud/ci_post_xcodebuild.sh` - Post-build script: collects `.xcresult`, uploads or archives logs/artifacts, and performs cleanup steps. It is intentionally generic and omits any secret upload logic.
- `github-actions/android_ci.yml` — Android continuous-integration: checks out code, sets up JDK and Flutter on an Ubuntu runner, runs `flutter pub get`, `flutter analyze`, `flutter test`, builds a debug APK and a release AAB, and uploads build artifacts.
- `github-actions/android_release.yml` — Android release: triggered by tag or manual dispatch; builds an obfuscated release App Bundle (AAB) and uploads the artifact. A placeholder step shows where to hook a Fastlane or Play Store publish step (disabled by default).
- `github-actions/ios_ci.yml` — iOS continuous-integration: runs on `macos-latest`, installs CocoaPods, runs `flutter pub get`, analyzes, tests, builds an IPA, and uploads artifacts.
- `github-actions/ios_release.yml` — iOS release: triggered by tag or manual dispatch; builds a release IPA and uploads the artifact. A placeholder step shows where to wire Fastlane / App Store Connect uploads (disabled by default).

Secrets and environment variables
---------------------------------
Secrets are used in GitHub Secrets, Xcode Cloud environment variables, or other secure secret stores. 
