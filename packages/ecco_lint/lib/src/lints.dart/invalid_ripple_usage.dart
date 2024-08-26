import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A lint rule that checks for invalid usage of the ripple method in EccoNotifier.
///
/// This rule warns when the ripple method is called with a simple identifier,
/// which likely indicates that a new state object is not being created.
/// The ripple method should always be called with a new state object to ensure
/// proper state management in the Ecco framework.
class InvalidRippleUsage extends DartLintRule {
  /// Creates a new instance of the InvalidRippleUsage lint rule.
  const InvalidRippleUsage() : super(code: _code);

  static const _code = LintCode(
    name: 'invalid_ripple_usage',
    errorSeverity: ErrorSeverity.WARNING,
    problemMessage:
        'The ripple method should be called with a new state object',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      if (node.methodName.name == 'ripple') {
        final target = node.target;
        if (target is SimpleIdentifier &&
            target.staticType.toString().startsWith('EccoNotifier')) {
          final argument = node.argumentList.arguments.first;
          if (argument is SimpleIdentifier) {
            reporter.reportErrorForNode(_code, node);
          }
        }
      }
    });
  }
}
