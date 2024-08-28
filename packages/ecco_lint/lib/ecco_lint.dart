import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/assists/wrap_with_ecco_builder.dart';
import 'src/assists/wrap_with_ecco_consumer.dart';
import 'src/lints/avoid_dynamic_ecco_notifier.dart';
import 'src/lints/invalid_ripple_usage.dart';
import 'src/lints/missing_ecco_provider.dart';

/// Creates and returns an instance of the Ecco lint plugin.
///
/// This function serves as the entry point for the custom lint system,
/// instantiating the main plugin class that defines all custom lints
/// and assists for the Ecco framework.
///
/// Returns:
///   A [PluginBase] instance, specifically an [_EccoLint] object,
///   which encapsulates all the custom lint rules and assists.
PluginBase createPlugin() => _EccoLint();

/// A custom lint plugin for the Ecco state management framework.
///
/// This plugin provides lint rules and assists specific to Ecco usage,
/// helping developers adhere to best practices and avoid common pitfalls
/// when working with the Ecco framework.
class _EccoLint extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const AvoidDynamicEccoNotifier(),
        const MissingEccoProvider(),
        const InvalidRippleUsage(),
      ];

  @override
  List<Assist> getAssists() => [
        WrapWithEccoBuilder(),
        WrapWithEccoConsumer(),
      ];
}
