//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/16
//
import 'package:flutter/material.dart';
import 'package:leaves/constant/filter_mode.dart';
import 'package:leaves/providers/filters_provider.dart';
import 'package:provider/provider.dart';

class FilterModesPage extends StatefulWidget {
  const FilterModesPage({Key? key, required this.initialMode}) : super(key: key);

  final FilterMode initialMode;

  @override
  State<FilterModesPage> createState() => _FilterModesPageState();
}

class _FilterModesPageState extends State<FilterModesPage> {
  late FilterMode _filterMode;

  @override
  void initState() {
    super.initState();
    _filterMode = widget.initialMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("模式选择"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final mode in FilterMode.values) ...[
            Container(
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.only(left: 20, right: 10),
              child: RadioListTile(
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: EdgeInsets.zero,
                value: mode,
                title: Text(mode.title),
                groupValue: _filterMode,
                onChanged: (val) {
                  setState(
                    () {
                      _filterMode = val!;
                      context.read<FiltersProvider>().setFilterMode(val);
                      Navigator.of(context).pop(val);
                    },
                  );
                },
              ),
            ),
            Divider(
              height: 0,
              thickness: 0.5,
            ),
          ]
        ],
      ),
    );
  }
}
