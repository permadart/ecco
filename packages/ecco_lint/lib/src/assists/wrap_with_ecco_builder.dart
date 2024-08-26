import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// An assist that wraps a widget with an EccoBuilder.
///
/// This assist can be applied to any widget to wrap it with an EccoBuilder,
/// which is useful for widgets that need to rebuild based on state changes.
class WrapWithEccoBuilder extends DartAssist {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    SourceRange target,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (!target.intersects(node.constructorName.sourceRange)) return;

      final changeBuilder = reporter.createChangeBuilder(
        message: 'Wrap with EccoBuilder',
        priority: 3,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleInsertion(
          node.offset,
          'EccoBuilder<YourStateType>(\n'
          '  builder: (context, state) {\n'
          '    return ',
        );
        builder.addSimpleInsertion(
          node.end,
          ';\n'
          '  },\n'
          ')',
        );
      });
    });
  }
}
