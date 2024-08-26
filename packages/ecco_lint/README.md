# ecco_lint

A custom lint package for the Ecco state management framework in Flutter.

## Features

ecco_lint provides custom lint rules and assists to help developers use the Ecco framework correctly and efficiently:

### Lint Rules

- `avoid_dynamic_ecco_notifier`: Warns against using dynamic types for EccoNotifier.
- `missing_ecco_provider`: Ensures EccoBuilder and EccoConsumer are used within an EccoProvider.
- `invalid_ripple_usage`: Checks for correct usage of the ripple method in EccoNotifier.

### Assists

- `wrap_with_ecco_builder`: Helps wrap a widget with EccoBuilder.
- `wrap_with_ecco_consumer`: Helps wrap a widget with EccoConsumer.

## Installation

Add `ecco_lint` to your `pubspec.yaml` file:

```yaml
dev_dependencies:
  ecco_lint: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

To use ecco_lint in your project, add it to your analysis_options.yaml file:

```bash
include: package:ecco_lint/analysis_options.yaml
```

This will enable all the lint rules provided by ecco_lint. You can customize which rules to include or exclude in your `analysis_options.yaml` file.

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.