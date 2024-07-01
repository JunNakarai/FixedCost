import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fixed_cost_provider.dart';
import 'edit_fixed_cost_screen.dart';
import 'add_fixed_cost_screen.dart';

class FixedCostListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<FixedCostProvider>(
          builder: (context, provider, child) {
            return Text('合計金額: ${provider.getTotalFixedCost()}円');
          },
        ),
      ),
      body: Consumer<FixedCostProvider>(builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  provider.reorderFixedCosts(oldIndex, newIndex);
                },
                children: [
                  for (int index = 0; index < provider.fixCosts.length; index++)
                    ListTile(
                      key: Key('$index'),
                      title: Text(provider.fixCosts[index].name),
                      subtitle: Text('${provider.fixCosts[index].amount}円'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditFixedCostScreen(
                                    fixedCost: provider.fixCosts[index]),
                              ));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              provider.removeFixedCost(provider.fixCosts[index]);
                            },
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddFixedCostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}