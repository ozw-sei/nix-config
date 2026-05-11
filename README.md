# mac-nix

Nix + nix-darwin + Home Manager で管理するmacOS環境定義です。

## 現在の前提

- Mac: Apple Silicon (`aarch64-darwin`)
- Gitの個人名・会社メールはGit管理外のローカルファイルで管理
- Nix: インストール済み
- Homebrew: 未インストール

## Git Identity

このリポジトリでは、個人名・会社メールなどのGit identityをGit管理しません。

Home Managerが生成するGit設定から、次のローカルファイルを読みます。

```text
~/.config/git/config.local
```

必要なら雛形をコピーして作成します。

```sh
mkdir -p ~/.config/git
cp templates/git-config.local.example ~/.config/git/config.local
```

1Passwordで管理したい場合は、`config.local` の中身をSecure Noteなどに保存しておき、新しいMacではそこから復元する運用が扱いやすいです。`op read` で自動生成することもできますが、Nix評価時に1Passwordを直接読む構成にはしない方針です。

## 初回適用

このディレクトリで実行します。

```sh
sudo nix --extra-experimental-features "nix-command flakes" \
  run github:nix-darwin/nix-darwin/nix-darwin-25.11#darwin-rebuild -- \
  switch --flake .#mac
```

`sudo` 実行時に次の警告が出ることがありますが、これは `sudo` が一時的にroot側のHOMEへ倒しているだけで、nix-darwinの適用自体は続行できます。

```text
warning: $HOME ('/Users/<username>') is not owned by you, falling back to the one defined in the 'passwd' file ('/var/root')
```

初回activationで `/etc/bashrc` と `/etc/zshrc` が未管理ファイルとして止められた場合は、既存ファイルを退避してから再実行します。

```sh
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

初回適用後は、flakes が有効化されるので短くできます。

```sh
sudo darwin-rebuild switch --flake .#mac
```

Makefile からも実行できます。

```sh
make build
make switch
```

Home Manager 側の zsh エイリアスとして、次も使えます。

```sh
rebuild
```

## 更新

依存関係を更新してから再適用します。

```sh
nix flake update
sudo darwin-rebuild switch --flake .#mac
```

## ファイル構成

- `flake.nix`: 入力バージョンと全体の接続
- `hosts/mac/configuration.nix`: macOS / nix-darwin 側の設定
- `home/default.nix`: ユーザー環境、CLIツール、シェル設定
- `templates/git-config.local.example`: Git identity用ローカル設定の雛形

## 次に足すとよいもの

- Git の `user.name` / `user.email`
- GUIアプリ管理。Nixだけで足りないものが出たら、Homebrewを入れて `nix-darwin` から管理
- SSH設定、GPG/1Password連携、言語別ツールチェーン
- DockやFinderの好み

## メモ

- `direnv` 2.37.1 のmacOSビルドでfishテストが `Killed: 9` になることがあるため、現時点では `programs.direnv.package` でチェックだけ無効化しています。
