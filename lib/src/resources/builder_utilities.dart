import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';

import '../exceptions/data_class_exceptions.dart';
import '../models/data_class_element.dart';

mixin BuilderUtilities {
  static Future<String?> getElementDeclaration(Element element) async {
    if (element is! ClassElement &&
        element is! ConstructorElement &&
        element is! MethodElement) {
      return null;
    }

    final library = element.library!;

    final result = library.session.getParsedLibraryByElement2(library)
        as ParsedLibraryResult;

    return result.getElementDeclaration(element)!.node.toSource();
  }

  static Future<void> _validateConstructorName(
      ConstructorElement element, String name) async {
    final node = await getElementDeclaration(element);

    if (node == null) return null;

    final result = node.split('=').last.trim();

    var declaration = '${element.type.returnType}';

    if (element.name.isNotEmpty) {
      final name = '$declaration.${element.name}';

      declaration = declaration.replaceFirst(declaration, name);
    }

    declaration += ((node.split('(')..first = '(').join('').split(')')
          ..last = ')')
        .join('');

    if (result != name) {
      throw DataClassException(element.type.returnType.element as ClassElement);
    }
  }

  static Future<DataClassElement> checkElement(Element element) async {
    if (element is! ClassElement) {
      throw 'You must declare a data class as an abstract class';
    }

    if (!element.isAbstract) {
      throw DataClassException(element);
    }

    final name = element.name;

    if (!(await getElementDeclaration(element))!
        .contains('abstract class $name with _\$$name')) {
      throw DataClassException(element);
    }

    final constructor = element.unnamedConstructor;

    if (constructor == null || !constructor.isFactory) {
      throw DataClassException(element);
    }

    if (element.fields.isNotEmpty) {
      throw DataClassException.cannotDeclareVariables(element);
    }

    await _validateConstructorName(constructor, '_$name;');

    final fromJson = element.getNamedConstructor('fromJson');

    if (fromJson == null || !fromJson.isFactory || fromJson.isConst) {
      throw DataClassException(element);
    }

    final parameters = fromJson.parameters;

    final nullSafety = element.library.isNonNullableByDefault;

    if (parameters.length != 1 ||
        parameters.first.type.getDisplayString(withNullability: nullSafety) !=
            'Map<String, dynamic>') {
      throw DataClassException.invalidParameterForFromJson(element);
    }

    await _validateConstructorName(fromJson, '_$name.fromJson;');

    return DataClassElement(
      methods: element.methods,
      isConst: constructor.isConst,
      name: name,
      fields: constructor.parameters,
      nullSafety: nullSafety,
    );
  }

  static bool isClass(Element? element) =>
      element != null &&
      element is ClassElement &&
      !element.librarySource.isInSystemLibrary;

  static List<DartType> getTypeArgumentsFromList(DartType type) {
    if (type is! InterfaceType || !type.isDartCoreList) return [];

    final types = type.typeArguments
        .expand((element) => element.isDartCoreList
            ? [element, ...getTypeArgumentsFromList(element)]
            : [element])
        .toList();

    return types;
  }

  static bool isNullable(DartType type) =>
      type.isDynamic || type.nullabilitySuffix == NullabilitySuffix.question;
}
