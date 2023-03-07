import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';

class CurrentTrip extends StatefulWidget {
  const CurrentTrip({super.key});

  @override
  State<CurrentTrip> createState() => _CurrentTripState();
}

class _CurrentTripState extends State<CurrentTrip> {
  final _headerStyle = const TextStyle(color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  final _contentStyle = const TextStyle(color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
  final _loremIpsum = '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';

  @override
  Widget build(BuildContext context) {
    return Accordion(
      disableScrolling: true,
      maxOpenSections: 2,
      headerBackgroundColorOpened: Colors.black54,
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
      children: [
        AccordionSection(
          isOpen: false,
          leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
          headerBackgroundColor: Colors.black,
          headerBackgroundColorOpened: Colors.red,
          header: Text('Introduction', style: _headerStyle),
          content: Text(_loremIpsum, style: _contentStyle),
          contentHorizontalPadding: 20,
          contentBorderWidth: 1,
          // onOpenSection: () => print('onOpenSection ...'),
          // onCloseSection: () => print('onCloseSection ...'),
        ),
      ],
    );
  }
}
