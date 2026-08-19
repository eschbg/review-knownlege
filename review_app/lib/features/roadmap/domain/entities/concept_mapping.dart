import 'package:equatable/equatable.dart';

class ConceptMapping extends Equatable {
  final String id;
  final String topicName;
  final String flutterConcept;
  final String springConcept;
  final String keyInsight;
  final String flutterSnippet;
  final String springSnippet;

  const ConceptMapping({
    required this.id,
    required this.topicName,
    required this.flutterConcept,
    required this.springConcept,
    required this.keyInsight,
    required this.flutterSnippet,
    required this.springSnippet,
  });

  @override
  List<Object?> get props => [
        id,
        topicName,
        flutterConcept,
        springConcept,
        keyInsight,
        flutterSnippet,
        springSnippet,
      ];
}
