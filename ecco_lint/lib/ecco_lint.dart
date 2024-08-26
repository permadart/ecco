import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/assists/wrap_with_ecco_builder.dart';
import 'src/assists/wrap_with_ecco_consumer.dart';
import 'src/lints.dart/avoid_dynamic_ecco_notifier.dart';
import 'src/lints.dart/invalid_ripple_usage.dart';
import 'src/lints.dart/missing_ecco_provider.dart';

/// A custom lint plugin for the Ecco state management framework.
///
/// This plugin provides lint rules and assists specific to Ecco usage,
/// helping developers adhere to best practices and avoid common pitfalls
/// when working with the Ecco framework.
class EccoLint extends PluginBase {
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
