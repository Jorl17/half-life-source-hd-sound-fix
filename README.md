# half-life-source-hd-sound-fix

There is currently a bug in **Half-Life: Source** when you use the **HD texture/models** pack. Sound does not work correctly with some weapons or in certain scenarios (e.g. reloading) [1]. See [this Github issue](https://github.com/ValveSoftware/Source-1-Games/issues/1345) for more information. The "hard work" of this script was done by [malortie](https://github.com/malortie) in this issue.

**This script automatically fixes your Half-Life: Source so that HD texture/models work correctly.** It only works for OSX and Linux, but it should be easy to port to Windows if needed.

[1] There are no sounds when the pistol/glock, magnum, m4 and mp5 reload. Furthermore, the rifle and shotgun have missing sounds.

# How to run

In order to get your Half-Life: Source all dandy you can do the following steps:

```
git clone https://github.com/Jorl17/half-life-source-hd-sound-fix/
cd half-life-source-hd-sound-fix
chmod +x ./half-life-source-hd-sound-fix.sh
./half-life-source-hd-sound-fix.sh
```

Now go out and be a **Freeman**!

