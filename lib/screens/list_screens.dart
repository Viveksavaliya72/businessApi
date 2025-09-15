import 'package:businessapicall/model/business.dart';
import 'package:businessapicall/providers/business_provider.dart';
import 'package:businessapicall/screens/detail_screen.dart';
import 'package:businessapicall/widgets/business_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ListScrren extends StatefulWidget {
  const ListScrren({Key? key}) : super(key: key);

  @override
  State<ListScrren> createState() => _ListScrrenState();
}

class _ListScrrenState extends State<ListScrren> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_)=> BusinessProvider()..load(),
    child: Scaffold(
      appBar:AppBar(title: const Text('Businesses')),
      body: Consumer<BusinessProvider>(
        builder: (context,vm,_){
          if (vm.state == DataState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (vm.state == DataState.error) {
            return _ErrorState(vm);
          }else if (vm.state == DataState.empty) {
            return _EmptyState(vm);
          }else{
            final list = vm.filtered;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: vm.setQuery,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search businesses',
                    ),
                  ),
                ),
                Expanded(child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (ctx,idx){
                      final b = list[idx];
                      return BusinessCard<Business>(
                          item: b,
                          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>DetailScreen(b))),
                          builder:(c,item)=>Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(item.location),
                              const SizedBox(height: 4),
                              Text(item.contact),
                            ],
                          ),
                      );
                    }
                )),
              ],
            );
          }
        },
      ),
    ),
    );
  }
}
class _ErrorState extends StatelessWidget {
  final BusinessProvider vm;
  const _ErrorState(this.vm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Error: ${vm.errorMessage ?? 'Unknown error'}'),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: vm.load, child: const Text('Retry')),
      ]),
    );
  }
}
class _EmptyState extends StatelessWidget {
  final BusinessProvider vm;
  const _EmptyState(this.vm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('No businesses found'),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: vm.load, child: const Text('Reload')),
      ]),
    );
  }
}