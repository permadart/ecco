# Changelog

All notable changes to the Ecco package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1+1] - 2024-08-13

- Updated README.md with corrected examples for EccoBuilder and EccoConsumer
- Fixed inconsistencies in the Basic Setup section of README.md

## [0.0.1] - 2024-08-13

### Added
- Initial release of the Ecco package.
- Core functionality:
  - `EccoNotifier` for managing state.
  - `EccoProvider` for making state available to the widget tree.
  - `EccoBuilder` for rebuilding UI parts when state changes.
  - `EccoConsumer` for accessing both model and viewmodel in a widget.
- MVVM architecture support.
- Debug overlay for state visualization.
- Logging functionality with customizable log levels.
- Support for `Equatable` for efficient state comparisons.
- Basic example demonstrating usage of Ecco in a counter app.
- Comprehensive README with usage instructions and best practices.
- Unit tests covering core functionality.

### Known Issues
- Debug overlay may have performance impact on complex apps. Use with caution in production.