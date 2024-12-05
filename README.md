自行打包的 [ttyd](https://github.com/tsl0922/ttyd)，供 Debian 12 或其他发行版上使用。

> 可查看 [ttyd - Debian](https://packages.debian.org/search?keywords=ttyd&searchon=names&suite=all&section=all)，Debian 11 (bullseye) 都有，12 倒没了。Unstable 和 Debian 13 的仓库中有，不用添加。

## Usage/用法

```sh
echo "deb [trusted=yes] https://github.com/wcbing/ttyd-debs/releases/latest/download ./" |
    sudo tee /etc/apt/source.list.d/ttyd.list
sudo apt update
```