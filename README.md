# docker-bittorrent

Based on the original [docktorrent], this [Docker] container serves as a fully-featured BitTorrent client/server system, consisting of [rTorrent], [ruTorrent], and [flood]. It's incredibly easy to get started. Just pull the [Docker image] and start up a new container.

## Table of Contents

* [Features](#features)
* [Installation](#installation)
* [Configuration](#configuration)
* [Usage](#usage)
* [Building](#building)

## Features

* Designed with portability in mind. Run one command and you're good to go.
* No-hassle installation in less than a minute (assuming prerequisites are installed).
* Two [rTorrent] web clients to choose from: the aging-yet-robust [ruTorrent], or the modern-yet-inflexible [flood].
* Want to use both clients? No problem! Both are available to use and are interchangeable.
* Automatically restarts [rTorrent] if it hangs or freezes.
* Easy access to [rTorrent] CLI or [flood] terminal output via one command.

## Installation

There are two ways to go about installing this Docker container.

### Docker CE

Installation via [Docker CE] takes only one command, assuming you have [Docker CE] installed.

#### Prerequisites

* [Docker CE] installed.
* `docker` service running.

---

Assuming the above prerequisites are met, run the following command. The container will restart on boot automatically.

Replace the words `MAIN` with your desired web port, `PEER` with your desired incoming port, `DHT` with your desired DHT port, and `CONTENT` with an empty directory to store your content.

```bash
$ docker run --name bittorrent \
  --restart always -dit \
  -p MAIN:80 -p PEER:5000 -p 6881:6881 \
  -v CONTENT:/data/rtorrent \
  winneon/docker-bittorrent
```

To stop and/or start the container afterwards, run the following command(s).

```bash
$ docker stop bittorrent
$ docker start bittorrent
```

Afterwards, continue to the next section.

### Docker Compose

If you prefer to store these variables in a file, [Docker Compose] provides an alternative. The steps are a little less straightforward, but the end result is cleaner.

#### Prerequisites

* [Docker CE] installed.
* [Docker Compose] installed.
* `docker` service running.

---

Assuming the above prerequisites are met, download this repository's archive & unzip it. Open `docker-compose.yml` in your text editor of choice and replace the words `MAIN` with your desired web port, `PEER` with your desired incoming port, `DHT` with your desired DHT port, and `CONTENT` with an empty directory to store your content. Afterwards, run the following command inside the directory. The container will restart on boot automatically.

```bash
$ docker-compose up -d
```

To stop and/or start the container afterwards, run the following command(s).

```bash
$ docker-compose stop
$ docker-compose start
```

Afterwards, continue to the next section.

## Configuration

For most, the default configuration will be more than enough. However, if you use private trackers exclusively or like to tinker configurations, then this is the section for you. Otherwise, skip to the next section.

The following environment variables can be used to configure rTorrent.

* **PEERS**: overrides `throttle.max_peers.normal.set`, sets the maximum amount of peers per torrent while leeching
* **PEERS_SEED**: overrides `throttle.max_peers.seed.set`, sets the maximum amount of peers per torrent while seeding
* **DOWNLOADS**: overrides `throttle.max_downloads.set`, sets the maximum amount of simultaneous downloads
* **UPLOADS**: overrides `throttle.max_uploads.set`, sets the maximum amount of simultaneous uploads
* **DOWNLOAD_RATE**: overrides `throttle.global_down.max_rate.set_kb`, sets the maximum download rate in kb/s
* **UPLOAD_RATE**: overrides `throttle.global_up.max_rate.set_kb`, sets the maximum upload rate in kb/s
* **DHT**: overrides `dht.mode.set`, enables/disables DHT & peer discovery (set to on/off)

For example, the below `docker` command uses `UPLOAD_RATE` to override the maximum allowed upload rate to 1MB/s.

```bash
$ docker run --name bittorrent \
  --restart always -dit \
  -p 80:80 -p 5000:5000 -p 6881:6881 \
  -e UPLOAD_RATE=1024 \
  -v /media/alpha/rtorrent:/data/rtorrent \
  winneon/docker-bittorrent
```

If you prefer to use `docker-compose` instead, the below example uses `DOWNLOAD_RATE` to override the maximum allowed download rate to 1MB/s, within `docker-compose.yml`.

```yaml
version: '3'
services:
  bittorrent:
    image: winneon/docker-bittorrent
    build: .
    restart: always
    ports:
      - 80:80
      - 5000:5000
      - 6881:6881
    volumes:
      - /media/alpha/rtorrent:/data/rtorrent
    environment:
      - DOWNLOAD_RATE=1024
```

## Usage

Before we continue, ensure that your `PEER` and `DHT` ports that you set earlier are port-forwarded correctly, otherwise you may have issues connecting to peers and vice versa.

This Docker container is accessible in multiple ways:

* [ruTorrent] via web.
* [flood] via web.
* [rTorrent] via CLI.

### ruTorrent

To use [ruTorrent], open `http://127.0.0.1:MAIN/` in a web browser, replacing `MAIN` with the web port you bound (i.e. `http://127.0.0.1:8080/`). When prompted, input the username/password combo `bittorrent/bittorrent`.

To change the username/password, run the following command. Replace the words `USERNAME` and `PASSWORD` with your desired username & password, respectively. If you used the [Docker Compose] installation method, replace the word `bittorrent` with the container name that [Docker Compose] generated.

```bash
$ docker exec -it bittorrent htpasswd -cb /data/rutorrent/.htpasswd USERNAME PASSWORD
```

### flood

To use [flood], open `http://127.0.0.1:MAIN/flood/` in a web browser, replacing `MAIN` with the web port you bound (i.e. `http://127.0.0.1:8080/flood/`). Follow the on-screen instructions to create a flood account.

It is also possible to monitor [flood]'s `npm` terminal output if you so desire. To do so, run the following command. If you used the [Docker Compose] installation method, replace the word `bittorrent` with the container name that [Docker Compose] generated.

```bash
$ docker exec -it bittorrent screen -r flood
```

Detach from the screen by pressing `Ctrl+A, D`.

### rTorrent

To use [rTorrent] via a CLI, run the following command. This is not recommended for anyone other than experienced users. If you used the [Docker Compose] installation method, replace the word`bittorrent` with the container name that [Docker Compose] generated.

```bash
$ docker exec -it bittorrent screen -r rtorrent
```

Detach from the screen by pressing `Ctrl+A, D`.

## Building

If you prefer to build this image from source or you want to modify a wider-range of [rTorrent] options, follow the below instructions. As with installation, there are two ways to go about building this Docker image.

### Docker CE

#### Prerequisites

* [Docker CE] installed.
* `docker` service running.

---

Assuming the above prerequisites are met, run the following command. Replace the word `NAME` with your desired name of the image.

```bash
$ docker build -t NAME .
```

The build process may take upwards of 30 minutes on even modern machines. When it finishes, you can run the image via the [Docker CE] instructions laid out in the [Installation](#installation) section, with the major difference being you replacing `winneon/docker-bittorrent` with the name of the previously build image.

### Docker Compose

#### Prerequisites

* [Docker CE] installed.
* [Docker Compose] installed.
* `docker` service running.

---

Assuming the above prerequisites are met, run the following command.

```bash
$ docker-compose build
```

The build process may take upwards of 30 minutes on even modern machines. When it finishes, you can run the image via the [Docker Compose] instructions laid out in the [Installation](#installation) section.

[docktorrent]: https://github.com/kfei/docktorrent
[Docker]: https://www.docker.com/
[rTorrent]: https://github.com/rakshasa/rtorrent
[ruTorrent]: https://github.com/Novik/ruTorrent
[flood]: https://github.com/jfurrow/flood
[Docker image]: https://hub.docker.com/r/winneon/docker-bittorrent/
[Docker CE]: https://www.docker.com/community-edition
[Docker Compose]: https://docs.docker.com/compose/
