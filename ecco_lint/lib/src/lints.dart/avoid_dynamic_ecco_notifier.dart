import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A lint rule that warns against using dynamic type for EccoNotifier.
///
/// This rule helps maintain type safety by encouraging developers to specify
/// concrete types for EccoNotifier instances instead of using dynamic.
class AvoidDynamicEccoNotifier extends DartLintRule {
  /// Creates a new instance of the AvoidDynamicEccoNotifier lint rule.
  const AvoidDynamicEccoNotifier() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_dynamic_ecco_notifier',
    errorSeverity: ErrorSeverity.WARNING,
    problemMessage: 'Avoid using dynamic type for EccoNotifier',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final type = node.staticType;
      if (type == null) return;

      if (type.toString().startsWith('EccoNotifier<dynamic>')) {
        reporter.atNode(node, _code);
      }
    });
  }
}
