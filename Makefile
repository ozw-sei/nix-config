.PHONY: build switch rebuild update fmt check

FLAKE ?= .\#mac

build:
	darwin-rebuild build --flake $(FLAKE)

switch rebuild:
	sudo darwin-rebuild switch --flake $(FLAKE)

update:
	nix flake update

fmt:
	nixfmt flake.nix home/default.nix hosts/mac/configuration.nix

check:
	nix flake check
