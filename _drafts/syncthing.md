Very easy to install and run.

Just works.

Conflict files on a regular basis, but they've been always automatically handled up to now (just delete the .conflict files).
For this reason, git synchronization (or bundled mechanisms) might be a better choice for tools supporting it (e.g. passwordstore).

On Android it's sometimes stuck in "starting" state but apparently still synchronises ok. I suspect it's because of my custom configuration (either because of DnsChanger or ForceDoze)

Does not have an ios app (there is fsync, but not supported by syncthing team, I've not tested it).

Beware that if one host removes or moves files they will also be removed on other devices. You can use versioning to prevent data loss in this case.
