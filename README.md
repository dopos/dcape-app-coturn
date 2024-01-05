# dcape-app-coturn

[![GitHub Release][1]][2] [![GitHub code size in bytes][3]]() [![GitHub license][4]][5]

[1]: https://img.shields.io/github/release/dopos/dcape-app-coturn.svg
[2]: https://github.com/dopos/dcape-app-coturn/releases
[3]: https://img.shields.io/github/languages/code-size/dopos/dcape-app-coturn.svg
[4]: https://img.shields.io/github/license/dopos/dcape-app-coturn.svg
[5]: LICENSE

[coturn](https://github.com/coturn/coturn) application package for [dcape](https://github.com/dopos/dcape).
Based on [coturn-docker](https://github.com/m1rkwood/coturn-docker) repo.

## Notes

* Traefik [has no DTLS support](https://github.com/traefik/traefik/issues/6642)

## Docker image used

* [ghcr.io/coturn/coturn](https://github.com/coturn/coturn/pkgs/container/coturn)

## Requirements

* linux 64bit (git, make, sed)
* [docker](http://docker.io)
* [dcape](https://github.com/dopos/dcape) v2
* Git service ([github](https://github.com), [gitea](https://gitea.io) or [gogs](https://gogs.io))

## Install

### By mouse (deploy with drone)

* Gitea: Fork or mirror this repo in your Git service
* Drone: Activate repo
* Gitea: "Test delivery", config sample will be saved to enfist
* Enfist: Edit config and remove .sample from name
* Gitea: "Test delivery" again (or Drone: "Restart") - app will be installed and started on webhook host

### By hands

```bash
git clone --single-branch --depth 1 https://github.com/dopos/dcape-app-coturn.git
cd dcape-app-coturn
make config
... <edit .env.sample>
mv .env.sample .env
make up
```

## License

The MIT License (MIT), see [LICENSE](LICENSE).

Copyright (c) 2022 Aleksei Kovrizhkin <lekovr+dopos@gmail.com>
