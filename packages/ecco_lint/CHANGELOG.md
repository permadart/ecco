# Changelog

All notable changes to the ecco_lint package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1+2] - 2024-08-26

### Changed
- Changed linter plugin creation.
- Updated installation instructions.

## [0.0.1+1] - 2024-08-26

### Changed
- Introduced deprecated `reportErrorForNode` to support older versions of project's dependencies.

## [0.0.1] - 2024-08-26

### Added
- Initial release of ecco_lint.
- Lint Rules:
  - `avoid_dynamic_ecco_notifier`
  - `missing_ecco_provider`
  - `invalid_ripple_usage`
- Assists:
  - `wrap_with_ecco_builder`
  - `wrap_with_ecco_consumer`
- README.md with usage instructions and feature list.
- CHANGELOG.md to track changes across versions.