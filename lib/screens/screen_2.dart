import 'dart:async';
import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/images.dart';
import '../providers/base_items_provider.dart';
import '../providers/horizontal_items.dart';
import '../providers/vertical_items.dart';

class Screen2 extends StatefulWidget {
  const Screen2({Key key}) : super(key: key);

  static const routeName = '/screen_2';

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final HorizontalItemsProvider _horizontalItemProvider =
      HorizontalItemsProvider();
  final VerticalItemsProvider _verticalItemProvider = VerticalItemsProvider();

  int _horizontalListViewCount;
  int _verticalListViewCount;


  @override
  void initState() {
    _horizontalListViewCount = _horizontalItemProvider.itemsCount;
    _verticalListViewCount = _verticalItemProvider.itemsCount;
    super.initState();
  }

  void _closeWidget() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColor.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ABCancelButton(
            onPressed: _closeWidget,
          ),
          ListViewHeader(
            itemCount: _horizontalListViewCount,
            sectionIndex: 1,
            padding: const EdgeInsets.only(left: 20, bottom: 8),
          ),
          ABListView(
            itemCount: _horizontalListViewCount,
            provider: _horizontalItemProvider,
            axis: Axis.horizontal,
            axisName: "Horizontal",
          ),
          ListViewHeader(
            itemCount: _verticalListViewCount,
            sectionIndex: 2,
            padding: const EdgeInsets.only(left: 20, top: 8),
          ),
          Expanded(
            flex: 1,
            child: ABListView(
              itemCount: _verticalListViewCount,
              provider: _verticalItemProvider,
              axis: Axis.vertical,
              axisName: "Vertical",
            ),
          ),
        ],
      ),
    );
  }
}

class ABCancelButton extends StatelessWidget {
  const ABCancelButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 44),
          child: MaterialButton(
            onPressed: onPressed,
            child: Image.asset(
              ProjectImagePath.cancel,
              height: 24,
              width: 24,
            ),
          ),
        ),
      ],
    );
  }
}

class ABListView extends StatelessWidget {
  const ABListView({
    Key key,
    @required int itemCount,
    @required BaseItemsProvider provider,
    @required Axis axis,
    @required String axisName,
  })  : _itemCount = itemCount,
        _provider = provider,
        _axis = axis,
        _axisName = axisName,
        super(key: key);

  final int _itemCount;
  final BaseItemsProvider _provider;
  final Axis _axis;
  final String _axisName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ProjectColor.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      height: 160, //MediaQuery.of(context).size.height * 0.35,
      child: ListView.builder(
          scrollDirection: _axis,
          itemCount: _itemCount,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              width: MediaQuery.of(context).size.width * 0.88,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: ProjectColor.white,
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.15),
                            spreadRadius: 0,
                            blurRadius: 8,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _provider.itemAt(index) ?? "$_axisName item: 102",
                          style: const TextStyle(
                              color: ProjectColor.black,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class ListViewHeader extends StatelessWidget {
  const ListViewHeader({
    Key key,
    @required int itemCount,
    @required int sectionIndex,
    @required EdgeInsetsGeometry padding,
  })  : countItem = itemCount,
        index = sectionIndex,
        _padding = padding,
        super(key: key);

  final int countItem;
  final int index;
  final EdgeInsetsGeometry _padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Text(
        "Section $index ($countItem)",
        style: const TextStyle(
          color: ProjectColor.black,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
