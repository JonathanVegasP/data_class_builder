import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../types/class_type_builder.dart';
import '../types/mixin_type_builder.dart';

class DataElement {
  final String name;
  final bool nullSafety;
  final bool isConst;
  final List<ParameterElement> fields;
  final DartType? entity;
  final _mixin = MixinTypeBuilder();
  final _class = ClassTypeBuilder();

  DataElement({
    required this.name,
    required this.nullSafety,
    required this.isConst,
    required this.fields,
    this.entity,
  });

  factory DataElement.fromElement(Element element) {
    final name = element.name!;

    if (element is! ClassElement || !element.isAbstract) {
      throw 'DataBuilder: $name must be an abstract class';
    }

    final elementDeclaration = (element.session!
            .getParsedLibraryByElement2(element.library) as ParsedLibraryResult)
        .getElementDeclaration(element)!
        .node
        .toSource();

    final regex =
        RegExp(r'abstract class (' '$name' r')+ with _\$(' '$name' r')+ {');

    if (!regex.hasMatch(elementDeclaration)) {
      throw '$name must be declared as: abstract class $name with _\$$name {';
    }

    if (element.fields.isNotEmpty &&
        element.accessors.length != element.fields.length) {
      throw 'Variables in the $name must be declared in the factory default constructor';
    }

    final defaultConstructor = element.getNamedConstructor('_');

    if (defaultConstructor == null ||
        defaultConstructor.isFactory | !defaultConstructor.isConst) {
      throw 'Must declare a default const constructor as: const $name._();';
    }

    final constructor = element.unnamedConstructor;

    if (constructor == null || !constructor.isFactory) {
      throw 'Must declare a factory constructor as const factory/factory $name(/** Fields...*/) = _$name;';
    }

    final constructorDeclaration =
        (constructor.session!.getParsedLibraryByElement2(constructor.library)
                as ParsedLibraryResult)
            .getElementDeclaration(constructor)!
            .node
            .toSource()
            .split('=');

    final constructorRegex = RegExp(r'^ _(' '$name' r')+;$');

    if (!constructorRegex.hasMatch(constructorDeclaration.last)) {
      throw 'Must declare a factory constructor as const factory/factory $name(/** Fields...*/) = _$name;';
    }

    final fromJson = element.getNamedConstructor('fromJson');

    if (fromJson == null || !fromJson.isFactory | fromJson.isConst) {
      throw 'Must declare a non constant factory fromJson as: factory $name.fromJson(Map<String, dynamic> json) = _$name.fromJson;';
    }

    final fromJsonDeclaration =
        (fromJson.session!.getParsedLibraryByElement2(fromJson.library)
                as ParsedLibraryResult)
            .getElementDeclaration(fromJson)!
            .node
            .toSource()
            .split('=');

    final fromJsonRegex = RegExp(r'^ _[' '$name' r']+\.fromJson;$');

    if (!fromJsonRegex.hasMatch(fromJsonDeclaration.last)) {
      throw 'Must declare a non constant factory fromJson as: factory $name.fromJson(Map<String, dynamic> json) = _$name.fromJson;';
    }

    final nullSafety = element.library.isNonNullableByDefault;

    if (fromJson.parameters.length != 1 ||
        fromJson.parameters.last.type
                .getDisplayString(withNullability: nullSafety) !=
            'Map<String, dynamic>') {
      throw 'The constructor fromJson must has only a parameter typed as Map<String, dynamic>';
    }

    final toJson = element.getMethod('toJson');

    if (toJson == null ||
        toJson.returnType.getDisplayString(withNullability: nullSafety) !=
            'Map<String, dynamic>' ||
        toJson.parameters.isNotEmpty |
            toJson.typeParameters.isNotEmpty |
            !toJson.isAbstract) {
      throw 'The method toJson must be declared as: Map<String, dynamic> toJson();';
    }

    final entity = element.metadata
        .map((e) => e.computeConstantValue())
        .firstWhere((element) => element!.type!.element!.name == 'DataClass')!
        .getField('entity')!
        .toTypeValue();

    if (entity != null) {
      final fromEntity = element.getNamedConstructor('fromEntity');

      final type = entity.getDisplayString(withNullability: false);

      if (fromEntity == null) {
        throw 'Must be declared a non constant factory fromEntity as $name.fromEntity($type entity) = _$name.fromEntity;';
      }

      if (fromEntity.parameters.length != 1 ||
          fromEntity.parameters.last.type
                  .getDisplayString(withNullability: nullSafety) !=
              type) {
        throw 'The constructor fromEntity must has only a parameter typed as $type';
      }

      final toEntity = element.getMethod('toEntity');

      if (toEntity == null ||
          toEntity.returnType.getDisplayString(withNullability: nullSafety) !=
              type ||
          toEntity.parameters.isNotEmpty ||
          toEntity.typeParameters.isNotEmpty ||
          !toEntity.isAbstract) {
        throw 'The method toEntity must be declared as: $type toEntity();';
      }
    }

    return DataElement(
      name: name,
      fields: constructor.parameters,
      isConst: constructor.isConst,
      nullSafety: nullSafety,
      entity: entity,
    );
  }

  String toDataClassDeclaration() {
    final buffer = StringBuffer();

    buffer.writeln(_mixin.declaration(element: this));
    buffer.write(_class.declaration(element: this));

    return buffer.toString();
  }
}
