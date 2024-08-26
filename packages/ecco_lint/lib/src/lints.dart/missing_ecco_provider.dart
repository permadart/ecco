import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class MissingEccoProvider extends DartLintRule {
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
      print('MissingEccoProvider checking node of type: $type');

      if (type.startsWith('EccoConsumer') || type.startsWith('EccoBuilder')) {
        final hasProvider = _hasAncestorEccoProvider(node);
        if (!hasProvider) {
          print('Reporting missing EccoProvider for $type');
          reporter.reportErrorForNode(_code, node);
        }
      }
    });
  }

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
