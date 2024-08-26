import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AvoidDynamicEccoNotifier extends DartLintRule {
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
      print('Checking named type: $typeString'); // Debug print
      if (typeString.startsWith('EccoNotifier<dynamic>')) {
        print('Found EccoNotifier<dynamic>'); // Debug print
        reporter.reportErrorForNode(_code, node);
      }
    });

    context.registry.addClassDeclaration((node) {
      final superclassString = node.extendsClause?.superclass.toString() ?? '';
      print(
          'Checking class declaration: ${node.name}, superclass: $superclassString'); // Debug print
      if (superclassString.startsWith('EccoNotifier<dynamic>')) {
        print('Found class extending EccoNotifier<dynamic>'); // Debug print
        reporter.reportErrorForNode(_code, node.extendsClause!.superclass);
      }
    });
  }
}
