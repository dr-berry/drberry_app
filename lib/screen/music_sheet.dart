import 'package:flutter/material.dart';

class MusicSheetWidget extends StatefulWidget {
  const MusicSheetWidget({super.key});

  @override
  _MusicSheetWidgetState createState() => _MusicSheetWidgetState();
}

class _MusicSheetWidgetState extends State<MusicSheetWidget> {
  ScrollController? _scrollController;
  double _sheetSize = 0.1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController != null) {
      if (_scrollController!.offset <= _scrollController!.position.minScrollExtent &&
          !_scrollController!.position.outOfRange) {
        setState(() {
          _sheetSize = 0.1; // collapse
        });
      }
      if (_scrollController!.offset >= _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        setState(() {
          _sheetSize = 0.7; // expand
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: _sheetSize,
      minChildSize: 0.1,
      maxChildSize: 1,
      expand: false,
      builder: (BuildContext context, myScrollController) {
        return Container(
          color: Colors.blue[200],
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                _onScroll();
              }
              return true;
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text('Item ${index + 1}'));
              },
            ),
          ),
        );
      },
    );
  }
}
