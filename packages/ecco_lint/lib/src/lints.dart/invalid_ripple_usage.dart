import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class InvalidRippleUsage extends DartLintRule {
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
      print('Checking method invocation: ${node.methodName.name}');
      if (node.methodName.name == 'ripple') {
        print('Found ripple method call');
        print('Method source: ${node.toSource()}');

        final enclosingClass = node.thisOrAncestorOfType<ClassDeclaration>();
        print('Enclosing class: ${enclosingClass?.name.lexeme}');

        if (enclosingClass != null) {
          final classElement = enclosingClass.declaredElement;
          print('Class element: $classElement');

          if (classElement != null &&
              _isEccoNotifierSubtype(classElement.thisType)) {
            print('Ripple called in EccoNotifier subclass');
            final argument = node.argumentList.arguments.first;
            print('Ripple argument: ${argument.toSource()}');
            if (_isInvalidRippleArgument(argument)) {
              print('Reporting invalid ripple usage');
              reporter.reportErrorForNode(_code, node);
            } else {
              print('Ripple usage seems valid');
            }
          } else {
            print('Ripple not called in EccoNotifier subclass');
          }
        } else {
          print('Ripple not called within a class');
        }
      }
    });
  }

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

  bool _isInvalidRippleArgument(Expression argument) {
    if (argument is SimpleIdentifier && argument.name == 'state') {
      print('Invalid ripple argument: direct state usage');
      return true;
    }

    if (argument is PropertyAccess &&
        argument.propertyName.name == 'state' &&
        argument.target is ThisExpression) {
      print('Invalid ripple argument: this.state usage');
      return true;
    }

    print('Valid ripple argument');
    return false;
  }
}
