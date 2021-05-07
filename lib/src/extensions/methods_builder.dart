import 'package:analyzer/dart/element/element.dart';

import '../resources/builder_utilities.dart';

extension MethodsBuilder on StringBuffer {
  Future<void> writeMethods(List<MethodElement> methods) async {
    for (final method in methods) {
      writeln(await BuilderUtilities.getElementDeclaration(method));

      writeln();
    }
  }
}
