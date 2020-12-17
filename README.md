# Using CLI/Terminal on Apple M1 (MacOS Big Sur)

## `install_homebrew_native.sh`

* install Homebrew in native mode (without Rosetta 2) on a fresh Apple M1 Arm computer (MacOS Big Sur)
* run as: `curl -s https://raw.githubusercontent.com/pforret/macos_m1_cli/main/install_homebrew_native.sh | bash`

## Using native Homebrew

* as long as Homebrew does not officially support Apple M1 ARM architecture, 
  you will get the following warning every time you try to `brew install` a package
  

    Warning: You are running macOS on a arm64 CPU architecture.
    We do not provide support for this (yet).
    Reinstall Homebrew under Rosetta 2 until we support it.
    You will encounter build failures with some formulae.
    Please create pull requests instead of asking for help on Homebrew's GitHub,
    Twitter or any other official channels. You are responsible for resolving
    any issues you experience while you are running this
    unsupported configuration.

* you can however install the package by using `brew1 install`, 
  which is short for `brew --build-from-source install`
* the installation will probably work, but it's not guaranteed. 
  You are an early adopter, doing bleeding edge stuff, not for the faint of heart.

## `uninstall_homebrew_native.sh`

* if you prefer running in 'Rosetta 2' mode, you can uninstall the native mode Homebrew.
* run as: `curl -s https://raw.githubusercontent.com/pforret/macos_m1_cli/main/uninstall_homebrew_native.sh | bash`

## My Homebrew configuration

This is my config (on Mac Mini M1):

    HOMEBREW_VERSION: 2.6.2-91-g9db324a
    ORIGIN: https://github.com/Homebrew/brew
    HEAD: 9db324ab7a28446debcb407859c9ac184594a772
    Last commit: 6 hours ago
    Core tap ORIGIN: https://github.com/Homebrew/homebrew-core
    Core tap HEAD: 72f2ab4cf6ab6cf12044f083c0e062876357bf04
    Core tap last commit: 2 hours ago
    Core tap branch: master
    HOMEBREW_PREFIX: /opt/homebrew
    HOMEBREW_CASK_OPTS: []
    HOMEBREW_MAKE_JOBS: 8
    Homebrew Ruby: 2.6.3 => /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/bin/ruby
    CPU: octa-core 64-bit arm_firestorm_icestorm
    Clang: 12.0 build 1200
    Git: 2.24.3 => /Library/Developer/CommandLineTools/usr/bin/git
    Curl: 7.64.1 => /usr/bin/curl
    macOS: 11.0-arm64
    CLT: 12.3.0.0.1.1607026830
    Xcode: N/A
    Rosetta 2: false
