# docker-bittorrent

Based on the original [docktorrent], this [Docker] container serves as a fully-featured BitTorrent client/server system, consisting of [rTorrent], [ruTorrent], and [flood]. It's incredibly easy to get started. Just pull the [Docker image] and start up a new container.

## Features

* Designed with portability in mind. Run one command and you're good to go.
* No-hassle installation in less than a minute (assuming prerequisites are installed).
* Two [rTorrent] web clients to choose from: the aging-yet-robust [ruTorrent], or the modern-yet-inflexible [flood].
* Want to use both clients? No problem! Both are available to use and are interchangeable.
* Automatically restarts [rTorrent] if it hangs or freezes.
* Easy access to [rtorrent] or [flood] terminal output via one command.

## Installation

### Docker CE

Installation via [Docker CE] takes only one command, assuming you have [Docker CE] installed.

#### Prerequisites

* [Docker CE] installed.
* `docker` service running.

---

Assuming the above prerequisites are met, run the following command. The container will restart on boot automatically.

Replace the word `MAIN` with your desired web port, `PEER` with your desired incoming port, and `CONTENT` with an empty directory to store your content.

```bash
$ docker run --name bittorrent \
  --restart always -dit \
  -p MAIN:80 -p PEER:5000 \
  -v CONTENT:/data/rtorrent winneon/docker-bittorrent
```

Please refer to the [Usage](#usage) section for further instructions.

### Docker Compose

If you prefer to store these variables in a file, [Docker Compose] provides an alternative. The steps are a little less straightforward, but the end result is cleaner.

#### Prerequisites

* [Docker CE] installed.
* [Docker Compose] installed.
* `docker` service running.

---

Assuming the above prerequisites are met, download this repository's archive & unzip it. Open `docker-compose.yml` in your text editor of choice and replace the lines that have comments with your desired parameters. Afterwards, run the following command inside the directory.

```bash
$ docker-compose up
```

Please refer to the [Usage](#usage) section for further instructions.

## Usage

This Docker container is accessible in multiple ways:

* [ruTorrent] via web
* [flood] via web
* [rTorrent] via CLI

### ruTorrent

To use [ruTorrent], open `127.0.0.1:MAIN` in a web browser, replacing `MAIN` with the web port you bound (i.e. `127.0.0.:8080`). When prompted, input the username/password combo `bittorrent/bittorrent`.

To change the username/password, run the following command. Replace `USERNAME` and `PASSWORD` with your desired username & password, respectively.

```bash
$ docker exec -it bittorrent htpasswd -cb /data/rutorrent/.htpasswd USERNAME PASSWORD
```

### flood

To use [flood], open `127.0.0.1:MAIN/flood/` in a web browser, replacing `MAIN` with the web port you bound (i.e. `127.0.0.1:8080/flood/`). Follow the on-screen instructions to create a flood account.

It is also possible to monitor [flood]'s `npm` terminal output if you so desire. To do so, run the following command.

```bash
$ docker exec -it bittorrent screen -r flood
```

Detach from the screen by pressing `Ctrl+A, D`.

### rTorrent

To use [rTorrent] via a CLI, run the following command. This is not recommended for anyone other than experienced users.

```bash
$ docker exec -it bittorrent screen -r rtorrent
```

Detach from the screen by pressing `Ctrl+A, D`.

[docktorrent]: https://github.com/kfei/docktorrent
[Docker]: https://www.docker.com/
[rTorrent]: https://github.com/rakshasa/rtorrent
[ruTorrent]: https://github.com/Novik/ruTorrent
[flood]: https://github.com/jfurrow/flood
[Docker image]: https://hub.docker.com/r/winneon/docker-bittorrent/
[Docker CE]: https://www.docker.com/community-edition
[Docker Compose]: https://docs.docker.com/compose/
