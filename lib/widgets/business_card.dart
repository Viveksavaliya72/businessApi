import 'package:flutter/material.dart';

typedef CardBuilder<T> = Widget Function(BuildContext context,T item);

class BusinessCard<T> extends StatefulWidget {

  final T item;
  final CardBuilder<T> builder;
  final VoidCallback? onTap;

  const BusinessCard({Key? key,
    required this.item,
    required this.builder,
    this.onTap
  }) : super(key: key);

  @override
  State<BusinessCard> createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(

      onTap: widget.onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: widget.builder(context, widget.item),
        ),
      ),
    );
  }
}
