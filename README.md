# RezTink

A tinker / buff / portal / craft bot for Asheron's Call on ACE-based servers - a Decal plugin.

Players open a trade with the bot, hand over one item and any number of salvage bags, and accept.
The bot tells them what it received, gears up and buffs, sends the plan with the real odds for
every bag, applies them lowest workmanship first (imbue first), asks before anything under 100%,
and hands everything back at the end. It also handles trinkets, trinket armatures, buff items,
portals and crafting recipes. It keeps a ledger of everything it holds so nothing is ever lost, and
it has a ban list, gear suits per tinkering skill and a periodic announcement.

Current release: **RezTink-0.0.24**. Build names are `RezTink-0.0.22`, `RezTink-0.0.23`, ...

## Install

1. Download the newest `RezTink-*.dll` from the [releases page](https://github.com/ResistanceLab/RezTink/releases).
   If Windows blocked it: right-click it, Properties, tick *Unblock*.
2. Put it in a folder of its own (e.g. `C:\Games\Decal Plugins\RezTink\`), open the Decal agent,
   **Add**, and pick the DLL.
3. Log in. A "RezTink" window appears in the Virindi bar; tick **Bot enabled** or type `/rt start`.

The window title shows the running version.

## Updates

RezTink checks this repository at login. When a newer build is published, it downloads it,
verifies it and installs it for the next game start. The new build is installed under its own
versioned name (`RezTink-0.0.24.dll`, ...) and Decal is re-pointed at it, as long as the game runs
with administrator rights (RezLauncher does by default). Without those rights it replaces the file
in place. The previous build is kept next to it as `<old name>.prev`; delete that once you are
happy with the new build.

* `/rt update` checks right away.
* To receive only the chat notice and install by hand, create an empty file named
  `noautoupdate.txt` next to the DLL, or set `Update.Auto` to `false` in RezTink's `config.xml`.

## For players using the bot

Open a trade with the bot, add ONE item plus the salvage (and any buff items), and accept. Tell it
`help` for everything else: `tink` to queue when it's busy, `go` / `skip` / `stop` when it asks,
`lostitems` to get back anything it's still holding for you.

## Releasing a new build (maintainer notes)

The source lives in the private RezTink-Source repo. Its `publish.sh` builds, commits and tags the
source, then runs `release.sh` here. The steps below are what `release.sh` does, for a DLL that
was already built.

### Scripted

One-time setup in Git Bash:

    winget install GitHub.cli          # or download from https://cli.github.com
    gh auth login                      # browser login, pick HTTPS
    git clone https://github.com/ResistanceLab/RezTink.git
    cd RezTink

Each release:

    ./release.sh 0.0.24 "/c/path/to/RezTink-0.0.24.dll" "What changed"

The script computes the checksum, creates the release with the DLL attached, rewrites
`latest.txt` and pushes it. Players pick it up at their next login.

### Manual (what the script does)

1. Build the new DLL with the version bumped (`RezTink-0.0.24.dll`).
2. Create a GitHub release tagged exactly with the build id (`RezTink-0.0.24`) and attach the DLL
   under that name as an asset.
3. Edit `latest.txt` on `main`:
   - line 1: the new build id
   - line 2: `https://github.com/ResistanceLab/RezTink/releases/download/<build id>/<build id>.dll`
     (a tag-specific link)
   - line 3: SHA-256 of the DLL (optional but recommended)
   - remaining lines: short notes shown in chat
4. Players on older builds see the notice at their next login, and the DLL installs itself.

Note: the repository must stay **public** and keep its name. The plugin fetches
`https://raw.githubusercontent.com/ResistanceLab/RezTink/main/latest.txt` without any credentials.
