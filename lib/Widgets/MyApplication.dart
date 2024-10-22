import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notifier/Widgets/Network.dart';
import 'dart:math';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NOTIFIER'),
        ),
        body: Consumer<Counter>(
          builder: (context, counter, child) {
            final details = counter.getDetails();
            final isOpenList = counter.getOpenList();

            return Center(
              child: counter.isLoading // Use counter.isLoading directly
                  ? const CircularProgressIndicator()
                  : ListView.builder(
                      itemCount: details?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                    details![index].missionName ?? "error"),
                                subtitle:
                                    Text(details[index].missionId ?? "-999999"),
                                trailing: IconButton(
                                  icon: Icon(
                                    isOpenList![index]
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                  ),
                                  onPressed: () {
                                    counter.toggleOpen(index);
                                  },
                                ),
                              ),
                              if (isOpenList[index]) // Conditional rendering
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(details[index].description ??
                                          'error'),
                                      Wrap(
                                        spacing: 2,
                                        runSpacing: 2,
                                        children: details[index]
                                            .payloadIds!
                                            .map((payloadId) => Chip(
                                                  label: Text(payloadId),
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                    Random().nextInt(256),
                                                    Random().nextInt(256),
                                                    Random().nextInt(256),
                                                    255,
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          key: const Key("increment floatingActionButton"),
          onPressed: () {
            context.read<Counter>().fetchData(); // Directly trigger fetchData
          },
          tooltip: 'API Call',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
