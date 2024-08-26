import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A lint rule that checks for the presence of an EccoProvider when using EccoBuilder or EccoConsumer.
///
/// This rule helps ensure that EccoBuilder and EccoConsumer widgets are always used within the context
/// of an EccoProvider, which is necessary for proper state management in the Ecco framework.
class MissingEccoProvider extends DartLintRule {
  /// Creates a new instance of the MissingEccoProvider lint rule.
  const MissingEccoProvider() : super(code: _code);

  static const _code = LintCode(
    name: 'missing_ecco_provider',
    errorSeverity: ErrorSeverity.ERROR,
    problemMessage: 'EccoBuilder or EccoConsumer used without an EccoProvider',
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

      if (type.toString().startsWith('EccoBuilder') ||
          type.toString().startsWith('EccoConsumer')) {
        final enclosingClass = node.thisOrAncestorOfType<ClassDeclaration>();
        if (enclosingClass == null) return;

        final visitor = _EccoProviderVisitor();
        enclosingClass.accept(visitor);

        if (!visitor.hasProvider) {
          reporter.atNode(node, _code);
        }
      }
    });
  }
}

class _EccoProviderVisitor extends RecursiveAstVisitor<void> {
  bool hasProvider = false;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (node.staticType.toString().startsWith('EccoProvider')) {
      hasProvider = true;
    }
    super.visitInstanceCreationExpression(node);
  }
}
