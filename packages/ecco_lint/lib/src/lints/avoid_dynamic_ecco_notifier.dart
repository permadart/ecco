import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A custom lint rule that warns against using dynamic types for EccoNotifier.
///
/// This rule checks for instances where EccoNotifier is used with a dynamic type
/// parameter, which is generally discouraged as it defeats the purpose of
/// strong typing in the Ecco state management framework.
class AvoidDynamicEccoNotifier extends DartLintRule {
  /// Creates an instance of [AvoidDynamicEccoNotifier].
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
    context.registry.addNamedType((node) {
      final typeString = node.toString();
      if (typeString.startsWith('EccoNotifier<dynamic>')) {
        reporter.reportErrorForNode(_code, node);
      }
    });

    context.registry.addClassDeclaration((node) {
      final superclassString = node.extendsClause?.superclass.toString() ?? '';
      if (superclassString.startsWith('EccoNotifier<dynamic>')) {
        reporter.reportErrorForNode(_code, node.extendsClause!.superclass);
      }
    });
  }
}
