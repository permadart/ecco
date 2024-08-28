import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A custom lint rule that checks for invalid usage of the 'ripple' method in EccoNotifier subclasses.
///
/// This rule ensures that the 'ripple' method is called with a new state object,
/// rather than directly passing the current state or this.state.
class InvalidRippleUsage extends DartLintRule {
  /// Creates an instance of [InvalidRippleUsage].
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
        final enclosingClass = node.thisOrAncestorOfType<ClassDeclaration>();

        if (enclosingClass != null) {
          final classElement = enclosingClass.declaredElement;

          if (classElement != null &&
              _isEccoNotifierSubtype(classElement.thisType)) {
            final argument = node.argumentList.arguments.first;
            if (_isInvalidRippleArgument(argument)) {
              reporter.reportErrorForNode(_code, node);
            }
          }
        }
      }
    });
  }

  /// Checks if the given type is a subtype of EccoNotifier.
  ///
  /// This method recursively checks the superclass hierarchy to determine
  /// if the type is derived from EccoNotifier.
  bool _isEccoNotifierSubtype(DartType type) {
    if (type.toString().contains('EccoNotifier')) {
      return true;
    }
    final supertype = (type as InterfaceType).superclass;
    if (supertype == null) {
      return false;
    }
    return _isEccoNotifierSubtype(supertype);
  }

  /// Checks if the argument passed to the 'ripple' method is invalid.
  ///
  /// An argument is considered invalid if it's a direct reference to 'state'
  /// or 'this.state'.
  bool _isInvalidRippleArgument(Expression argument) {
    if (argument is SimpleIdentifier && argument.name == 'state') {
      return true;
    }

    if (argument is PropertyAccess &&
        argument.propertyName.name == 'state' &&
        argument.target is ThisExpression) {
      return true;
    }

    return false;
  }
}
