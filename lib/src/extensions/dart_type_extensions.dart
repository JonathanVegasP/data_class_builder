import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

final _dateTimeChecker = TypeChecker.fromRuntime(DateTime);
final _bigIntChecker = TypeChecker.fromRuntime(BigInt);
final _uriChecker = TypeChecker.fromRuntime(Uri);
final _durationChecker = TypeChecker.fromRuntime(Duration);

extension DartTypeExt on DartType {
  bool get isClass {
    final type = this;

    return type is InterfaceType &&
        !type.element.isEnum &&
        !type.element.isMixin &&
        !type.element.librarySource.isInSystemLibrary;
  }

  bool get hasFromJson =>
      isClass &&
      (element as ClassElement).getNamedConstructor('fromJson') != null;

  bool get hasToJson =>
      isClass && (element as ClassElement).getMethod('toJson') != null;

  bool get hasFromEntity =>
      isClass &&
      (element as ClassElement).getNamedConstructor('fromEntity') != null;

  bool get hasToEntity =>
      isClass && (element as ClassElement).getMethod('toEntity') != null;

  bool get isDateTime => _dateTimeChecker.isExactlyType(this);

  bool get isBigInt => _bigIntChecker.isExactlyType(this);

  bool get isUri => _uriChecker.isExactlyType(this);

  bool get isDuration => _durationChecker.isExactlyType(this);

  bool get isParseType => isBigInt | isUri | isDateTime;

  bool get isParseTypeArgument => isEnum | isParseType | isDuration;

  List<DartType> get collectionTypes => isDartCoreMap | isDartCoreList
      ? (this as InterfaceType)
          .typeArguments
          .expand((element) => [element, ...element.collectionTypes])
          .toList()
      : [];
}

extension ParameterElementExtension on ParameterElement {
  String? get jsonKey => metadata
      .map((element) => element.computeConstantValue())
      .firstWhere(
        (element) => element?.type?.element?.name == 'DataKey',
        orElse: () => null,
      )
      ?.getField('key')
      ?.toStringValue();
}

extension FieldElementExtension on FieldElement {
  String? get jsonKey => metadata
      .map((element) => element.computeConstantValue())
      .firstWhere(
        (element) => element?.type?.element?.name == 'DataKey',
        orElse: () => null,
      )
      ?.getField('key')
      ?.toStringValue();
}
