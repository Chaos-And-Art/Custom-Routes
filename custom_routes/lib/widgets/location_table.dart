import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/location_entry_model.dart';

class LocationTable extends StatefulWidget {
  const LocationTable({super.key, required this.entries});

  final List<LocationEntry> entries;

  @override
  State<LocationTable> createState() => _LocationTableState();
}

class _LocationTableState extends State<LocationTable> {
  @override
  Widget build(BuildContext context) {
    final sortedEntries = widget.entries.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Time')),
          DataColumn(label: Text('Latitude')),
          DataColumn(label: Text('Longitude')),
        ],
        rows: sortedEntries.map((entry) {
          return DataRow(cells: [
            DataCell(Text(DateFormat.yMd().format(entry.dateTime))),
            DataCell(Text(DateFormat.Hm().format(entry.dateTime))),
            DataCell(Text('${entry.latitude}')),
            DataCell(Text('${entry.longitude}')),
          ]);
        }).toList(),
      ),
    );
  }
}
