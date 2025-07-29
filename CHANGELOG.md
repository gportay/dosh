# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [unreleased]

### Added

 - Add `cqfd` man pages.
 - Add --platform option and `DOSH_PLATFORM` environment to support
   [multi-platform].
 - Describe `--tag`, `--ls`, `--rmi`, and `--gc` options in man page.
 - Describe `Untracked`, `Deleted`, `Outdated`,  and `Ready` image status in
   man page.
 - Add `Untracked` and internal `Unknown` status.
 - Add `--parent` option to bind-mount parent directory.

### Removed

 - Remove non-portable splitting hashbang single argument.
 - Remove "tag-redondant" `CHECKSUM` column.

### Changed

 - Change `--ls` output by adding `PLATFORM` and removing `CHECKSUM` columns.

### Fixed

 - Fix relative path with `--working-directory` option.
 - Fix mapping path to `dosh` in container.
 - Fix collecting unused images.

## [7] - 2025-07-01

Initial release.

[multi-platform]: https://docs.docker.com/build/building/multi-platform/
[unreleased]: https://github.com/gportay/dosh/compare/7...master
[7]: https://github.com/gportay/dosh/releases/tag/7
