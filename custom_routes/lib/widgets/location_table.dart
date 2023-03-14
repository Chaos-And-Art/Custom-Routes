import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
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
  int? _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final sortedEntries = widget.entries.toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    for (int i = 0; i < sortedEntries.length; i++) {
      sortedEntries[i].key = i;
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Locations Captured",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, decoration: TextDecoration.underline),
          ),
          DataTable(
            showCheckboxColumn: true,
            checkboxHorizontalMargin: 2,
            columnSpacing: 20,
            showBottomBorder: true,
            columns: const [
              DataColumn(
                  label: SizedBox(
                width: 80,
                child: Text(
                  'Date/Time',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              )),
              DataColumn(label: Text('')),
              DataColumn(
                  label: Text(
                'Latitude',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )),
              DataColumn(
                  label: Text(
                'Longitude',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )),
            ],
            onSelectAll: (val) {
              setState(() {
                _selectedIndex = -1;
              });
            },
            rows: sortedEntries.map((entry) {
              final index = entry.key;
              return DataRow(
                cells: [
                  // DataCell(Text(DateFormat('MMM d, yyyy').format(entry.dateTime))),
                  DataCell(SizedBox(
                    width: 80,
                    child: Text(
                      DateFormat('MMMM d  h:mm a').format(entry.dateTime),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  )),
                  const DataCell(Text('')),
                  DataCell(Text('${entry.latitude}')),
                  DataCell(Text('${entry.longitude}')),
                ],
                selected: index == _selectedIndex,
                onSelectChanged: (bool? value) {
                  setState(() {
                    _selectedIndex = value! ? index : null;
                  });
                  if (value == true) {
                    showActionDialog(context, entry);
                  } else {
                    setState(() {
                      entry.isSelected = false;
                    });
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> showActionDialog(BuildContext context, LocationEntry entry) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location ${entry.key! + 1}'),
          insetPadding: const EdgeInsets.all(10),
          content: SizedBox(
            width: 500,
            height: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRow('Date/Time:', DateFormat('MMMM d, h:mm a').format(entry.dateTime)),
                _buildRow('Latitude:', entry.latitude.toString()),
                _buildRow('Longitude:', entry.longitude.toString()),
                Accordion(
                  disableScrolling: true,
                  maxOpenSections: 1,
                  headerBackgroundColorOpened: Colors.black54,
                  scaleWhenAnimating: true,
                  openAndCloseAnimation: true,
                  headerPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
                  children: [
                    AccordionSection(
                      isOpen: false,
                      leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
                      headerBackgroundColor: Colors.black,
                      headerBackgroundColorOpened: Colors.red,
                      header: const Text("Descriptions", style: TextStyle(color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold)),
                      contentHorizontalPadding: 10,
                      contentBorderWidth: 1,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Descriptions", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "---",
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AccordionSection(
                      isOpen: false,
                      leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
                      headerBackgroundColor: Colors.black,
                      headerBackgroundColorOpened: Colors.red,
                      header: const Text("Images", style: TextStyle(color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold)),
                      contentHorizontalPadding: 10,
                      contentBorderWidth: 1,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Images", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "---",
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    //Navigate to new screen to Edit Location, add/remove images, etc.
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    //DELETE ENTRY
                    Navigator.of(context).pop();
                    setState(() {
                      _selectedIndex = -1;
                    });
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Widget _buildRow(String title, String content) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         flex: 2,
  //         child: Text(
  //           title,
  //           style: const TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //       Expanded(
  //         flex: 3,
  //         child: Text(content),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildRow(String title, String content) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Text(
                content,
                softWrap: true,
                overflow: TextOverflow.visible,
                maxLines: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
