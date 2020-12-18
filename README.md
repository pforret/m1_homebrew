# Using Homebrew on Apple Silicon M1 (MacOS Big Sur)

![](macos_m1_cli.jpg)
## `install_homebrew_native.sh`

* install Homebrew in native mode (without Rosetta 2) on a fresh Apple M1 Arm computer (MacOS Big Sur)
* run as: `curl -s https://raw.githubusercontent.com/pforret/macos_m1_cli/main/install_homebrew_native.sh | bash`

Output is like this:
```
### install_homebrew_native.sh from pforret/macos_m1_cli  Ⓜ️ 1️⃣
🍺 Create a folder for Homebrew ...
🍺 Download and install Homebrew from Github ...
🍺 Adding [/opt/homebrew/bin] to your zsh startup config path
🍺 Running brew a first time to trigger compilation
Initialized empty Git repository in /opt/homebrew/.git/
HEAD is now at 9db324ab7 Merge pull request #10045 from jonchang/remove-basic-autho
==> make CC=clang CFLAGS= YACC=yacc -d
🍺  /opt/homebrew/Cellar/awk/20180827: 7 files, 203.5KB, built in 3 seconds
🍺 Homebrew was installed as native binary. Version will be > 2.6
HOMEBREW_VERSION: 2.6.2-91-g9db324a
#====================================
🍺 Installation using 'brew install' will give a warning as long as Homebrew is not yet officially released for M1
🍺 You can use 'brew install -s' to always build from source and skip that warning
🍺 You might get build errors, but remember: you are an early adopter!
#====================================
🍺 Close this terminal and start a new one to make sure brew is in the path
```  

### Using native Homebrew

* as long as Homebrew does not officially support Apple M1 ARM architecture, 
  you will get the following warning every time you try to `brew install` a package

```  
Warning: You are running macOS on a arm64 CPU architecture.
We do not provide support for this (yet).
Reinstall Homebrew under Rosetta 2 until we support it.
You will encounter build failures with some formulae.
Please create pull requests instead of asking for help on Homebrew's GitHub,
Twitter or any other official channels. You are responsible for resolving
any issues you experience while you are running this
unsupported configuration.
```  

* you can however install the package by using `brew install -s`, 
  which is short for `brew install --build-from-source`
* packages with lots of dependencies (like e.g. ffmpeg) will often stop with the following error:
```  
Error: [some package]: no bottle available!
You can try to install from source with e.g.
brew install --build-from-source [some package]
```  
* you then have to `brew install --build-from-source` that dependency first, and run the main brew install again
* or use ...

### `rebrew.sh`

* **_recursive_ brew install -s** !!
* `rebrew.sh install ffmpeg` will first look up all the dependencies of ffmpeg, 
  build those one after the other and then run the main brew install. 
  It takes some time, but it works!


## `uninstall_homebrew_native.sh`

* if you prefer running in 'Rosetta 2' mode, you can uninstall the native mode Homebrew.
* run as: `curl -s https://raw.githubusercontent.com/pforret/macos_m1_cli/main/uninstall_homebrew_native.sh | bash`

Output is like this:
```  
### uninstall_homebrew_native.sh from pforret/macos_m1_cli  Ⓜ️ 1️⃣
🧽 Removing [/opt/homebrew/bin] from your zsh startup config path
🧽 Deleting Homebrew from [/opt/homebrew]
Password:
🧽 Homebrew was uninstalled!
```  

## My Homebrew configuration

This is my current config (on Mac Mini M1, 18 Dec 2020):

    $ brew config
    HOMEBREW_VERSION: 2.6.2
    ORIGIN: https://github.com/Homebrew/brew
    HEAD: 1a52862e6d24cd3bf87bec557a8886a1a825ee3c
    Last commit: 4 days ago
    Core tap ORIGIN: https://github.com/Homebrew/homebrew-core
    Core tap HEAD: c06f553c5f07a31e06ebebf806286141e0af7e0b
    Core tap last commit: 40 minutes ago
    Core tap branch: master
    HOMEBREW_PREFIX: /opt/homebrew
    HOMEBREW_CASK_OPTS: []
    HOMEBREW_MAKE_JOBS: 8
    Homebrew Ruby: 2.6.3 => /System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/bin/ruby
    CPU: octa-core 64-bit arm_firestorm_icestorm
    Clang: 12.0 build 1200
    Git: 2.24.3 => /Library/Developer/CommandLineTools/usr/bin/git
    Curl: 7.64.1 => /usr/bin/curl
    macOS: 11.1-arm64
    CLT: 12.3.0.0.1.1607026830
    Xcode: N/A
    Rosetta 2: false


## More info
* [Workarounds for ARM-based Apple-Silicon Mac](https://github.com/mikelxc/Workarounds-for-ARM-mac)
