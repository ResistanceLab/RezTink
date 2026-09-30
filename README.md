# RezTink

A tinker / buff / portal / craft bot for Asheron's Call on ACE-based servers - a Decal plugin.

Players open a trade with the bot, hand over one item and any number of salvage bags, and accept.
The bot tells them what it received, gears up and buffs, sends the plan with the real odds for
every bag, applies them lowest workmanship first (imbue first), asks before anything under 100%,
and hands everything back at the end. It also handles trinkets, trinket armatures, buff items,
portals and crafting recipes, keeps a ledger of everything it holds so nothing is ever lost, and
has a ban list, gear suits per tinkering skill and a periodic announcement.

**Current version: 0.0.22** - `RezTink-0.0.22.dll`

## Install (once)

1. Download **`RezTink-0.0.22.dll`** from this repository (click the file, then *Download raw file*).
   If Windows blocked it: right-click it, Properties, tick *Unblock*.
2. Put it in your Decal plugins folder, open the Decal agent, **Add**, and pick the DLL.
3. Log in. A "RezTink" window appears in the Virindi bar; tick **Bot enabled** or type `/rt start`.

That's the only manual install. From then on RezTink **updates itself**: after you log in it checks
this repository, and when there's a newer build it downloads it, verifies its checksum and installs
it for the next time you start the game. Start the client as administrator (RezLauncher does by
default) so the new file keeps its versioned name; otherwise it replaces the old file in place, which
works just as well.

* `/rt update` checks right away.
* To turn automatic downloads off, set `Update.Auto` to `false` in RezTink's `config.xml`, or put an
  empty file named `noautoupdate.txt` next to the DLL. You'll still be told when a new build is out.
* The previous build is kept next to the new one as `*.prev` if you ever need to roll back.

## For players using the bot

Open a trade with the bot, add ONE item plus the salvage (and any buff items), and accept. Tell it
`help` for everything else: `tink` to queue when it's busy, `go` / `skip` / `stop` when it asks,
`lostitems` to get back anything it's still holding for you.

`latest.txt` in this repository is the update manifest the plugin reads - please don't link to it
directly or rename this repository.
