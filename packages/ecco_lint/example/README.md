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

Run this command in the root of your Flutter project:

```bash
flutter pub add -d ecco_lint custom_lint
```

Then edit your `analysis_options.yaml` file and add these lines of code:

```bash
analyzer:
  plugins:
    - custom_lint
```

Then run:

```bash
flutter clean
flutter pub get
dart run custom_lint
```

This will enable all the lint rules provided by `ecco_lint`.

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.