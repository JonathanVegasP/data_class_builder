library data_class_builder.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/data_class_builder.dart';

Builder dataClassBuilder(BuilderOptions options) => PartBuilder(
      const [DataClassBuilder()],
      '.data.dart',
    );
