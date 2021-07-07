library data_builder.builder;

import 'package:build/build.dart';
import 'src/builders/entity/entity_builder.dart';
import 'package:source_gen/source_gen.dart';

import 'src/builders/data/data_builder.dart';

Builder dataBuilder(BuilderOptions options) =>
    PartBuilder(const [DataBuilder()], '.data.dart');

Builder entityBuilder(BuilderOptions options) =>
    PartBuilder(const [EntityBuilder()], '.entity.dart');
