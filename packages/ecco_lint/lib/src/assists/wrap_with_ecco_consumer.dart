import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A custom lint assist that wraps a widget with an EccoConsumer.
///
/// This assist can be applied to any widget to wrap it with an EccoConsumer,
/// which is useful for widgets that need access to both state and ViewModel
/// in the Ecco state management framework.
class WrapWithEccoConsumer extends DartAssist {
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
        message: 'Wrap with EccoConsumer',
        priority: 3,
      );

      changeBuilder.addDartFileEdit((builder) {
        builder.addSimpleInsertion(
          node.offset,
          'EccoConsumer<YourStateType, YourViewModelType>(\n'
          '  builder: (context, state, viewModel) {\n'
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
