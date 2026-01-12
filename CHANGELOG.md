# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [9] - 2026-01-12

### Added

 - Output commands to stderr if `--verbose`
 - Prints raw build process on verbose
 - Add `cqfd`'s verbose option
 - Optionize `cqfd`'s release command
 - Add `cqfd`'s deinit command
 - Add `cqfd`'s ls command
 - Add `cqfd`'s gc command
 - Add `Running` status
 - Add `--cache-directory` option
 - Add `--rc` option

### Changed

 - Store cached images by backend
 - Do not collect image with a running container
 - Do not remove running image
 - Output garbage collected details
 - Build image from `Dockerfile`'s parent directory
 - Output note if `ADD` or `COPY` instructions and if no `.dockerignore` file
 - Handle exec form instruction parameters

### Fixed

 - Fix cqfd's CQFD_NO_USER_GIT_CONFIG environment.
 - Fix cqfd's quiet option.

## [8] - 2025-08-01

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
[unreleased]: https://github.com/gportay/dosh/compare/9...master
[7]: https://github.com/gportay/dosh/releases/tag/7
[8]: https://github.com/gportay/dosh/releases/tag/8
[9]: https://github.com/gportay/dosh/releases/tag/9
