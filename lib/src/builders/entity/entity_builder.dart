import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:data_annotation/data_annotation.dart';
import 'package:data_builder/src/builders/entity/models/entity_element.dart';
import 'package:source_gen/source_gen.dart';

class EntityBuilder extends GeneratorForAnnotation<EntityAnnotation> {
  const EntityBuilder();

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return EntityElement.fromElement(element).declaration();
  }
}
