import 'package:flutter/material.dart';

class ProfanitySwitch extends StatefulWidget {
  final bool showAll;
  final Function(bool) onToggle;

  const ProfanitySwitch({super.key, required this.showAll, required this.onToggle});

  @override
  ProfanitySwitchState createState() => ProfanitySwitchState();
}

class ProfanitySwitchState extends State<ProfanitySwitch> {
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _showAll = widget.showAll;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Show profanity'),
      value: _showAll,
      onChanged: (value) {
        setState(() {
          _showAll = value;
          widget.onToggle(_showAll);
        });
      },
    );
  }
}
