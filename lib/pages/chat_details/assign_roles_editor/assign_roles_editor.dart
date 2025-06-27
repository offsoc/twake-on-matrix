import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class AssignRolesEditor extends StatefulWidget {
  final Room room;

  const AssignRolesEditor({
    super.key,
    required this.room,
  });

  @override
  AssignRolesEditorController createState() => AssignRolesEditorController();
}

class AssignRolesEditorController extends State<AssignRolesEditor> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
