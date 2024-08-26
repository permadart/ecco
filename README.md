# Ecco Project

This project contains two packages: `ecco` and `ecco_lint`. Ecco is a simple, MVVM-focused state management solution for Flutter, while Ecco Lint provides custom linting rules for Ecco projects.

## Packages

### Ecco

Ecco is a lightweight state management solution for Flutter applications, focusing on the MVVM (Model-View-ViewModel) architecture. It provides an intuitive way to manage application state and rebuild UI components efficiently.

[Read more about Ecco](./packages/ecco/README.md)

### Ecco Lint

Ecco Lint is a set of custom lint rules designed to enforce best practices and conventions when using the Ecco state management solution in Flutter projects.

[Read more about Ecco Lint](./packages/ecco_lint/README.md)

## Getting Started

To use these packages in your Flutter project, add them to your `pubspec.yaml` file:

```yaml
dependencies:
  ecco: ^0.0.1

dev_dependencies:
  ecco_lint: ^0.0.1
```

Then run:

```
flutter pub get
```

## Documentation

For detailed documentation on how to use each package, please refer to their respective README files:

- [Ecco Documentation](./packages/ecco/README.md)
- [Ecco Lint Documentation](./packages/ecco_lint/README.md)

## Contributing

We welcome contributions to both Ecco and Ecco Lint!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.