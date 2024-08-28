import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A custom lint rule that checks if EccoConsumer or EccoBuilder is used without an EccoProvider.
///
/// This rule ensures that EccoConsumer and EccoBuilder widgets are always used within
/// the context of an EccoProvider, which is essential for proper state management
/// in the Ecco framework.
class MissingEccoProvider extends DartLintRule {
  /// Creates an instance of [MissingEccoProvider].
  const MissingEccoProvider() : super(code: _code);

  static const _code = LintCode(
    name: 'missing_ecco_provider',
    errorSeverity: ErrorSeverity.WARNING,
    problemMessage: 'EccoConsumer or EccoBuilder used without an EccoProvider',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final type = node.staticType?.toString() ?? '';

      if (type.startsWith('EccoConsumer') || type.startsWith('EccoBuilder')) {
        final hasProvider = _hasAncestorEccoProvider(node);
        if (!hasProvider) {
          reporter.reportErrorForNode(_code, node);
        }
      }
    });
  }

  /// Checks if the given node has an EccoProvider ancestor.
  ///
  /// This method traverses up the widget tree to find if there's an EccoProvider
  /// wrapping the current EccoConsumer or EccoBuilder.
  ///
  /// Returns true if an EccoProvider is found, false otherwise.
  bool _hasAncestorEccoProvider(AstNode node) {
    AstNode? current = node.parent;
    while (current != null) {
      if (current is InstanceCreationExpression) {
        final type = current.staticType?.toString() ?? '';
        if (type.startsWith('EccoProvider')) {
          return true;
        }
      }
      current = current.parent;
    }
    return false;
  }
}
