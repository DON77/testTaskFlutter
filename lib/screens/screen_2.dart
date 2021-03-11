import 'dart:async';
import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/constants.dart';
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

  void _closeWidget() => Navigator.of(context).pop();

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

class ABListView extends StatefulWidget {
  const ABListView({
    Key key,
    @required int itemCount,
    @required BaseItemsProvider provider,
    @required Axis axis,
  })  : _itemCount = itemCount,
        _provider = provider,
        _axis = axis,
        super(key: key);

  final int _itemCount;
  final BaseItemsProvider _provider;
  final Axis _axis;

  @override
  _ABListViewState createState() => _ABListViewState();
}

class _ABListViewState extends State<ABListView> {
  bool _isLoading = false;
  int _initialElementsCount = 10;
  List<String> elements = [];

  Future _loadItem() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(_addPaginatedElements);
  }

  void _addPaginatedElements() {
    widget._itemCount - _initialElementsCount >=
            ProjectConstants.paginationAfterElementsCount
        ? _initialElementsCount += ProjectConstants.paginationAfterElementsCount
        : _initialElementsCount = widget._itemCount;

    for (var index = elements.length; index < _initialElementsCount; ++index) {
      elements.add(widget._provider.generateItemAt(index));
    }

    _isLoading = false;
  }

  void _setupInitialValues() {
    if (widget._itemCount < _initialElementsCount) {
      _initialElementsCount = widget._itemCount;
    }

    for (var index = 0; index < _initialElementsCount; ++index) {
      elements.add(widget._provider.generateItemAt(index));
    }
  }

  @override
  void initState() {
    _setupInitialValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ProjectColor.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      height: 160, //MediaQuery.of(context).size.height * 0.35,
      child: Stack(
        children: [
          _buildListView(),
          ABCircullarProgressIndicator(isLoading: _isLoading),
        ],
      ),
    );
  }

  NotificationListener<ScrollNotification> _buildListView() {
    return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (!_isLoading &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              _loadItem();

              setState(() {
                _isLoading = true;
              });
            }
            return true;
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: widget._axis,
            itemCount: elements.length, //widget._itemCount,
            itemBuilder: _buildItemView,
          ),
        );
  }

  Container _buildItemView(BuildContext context, int index) {
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
                  elements[index],
                  //_provider.generateItemAt(index),
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
  }
}

class ABCircullarProgressIndicator extends StatelessWidget {
  const ABCircullarProgressIndicator({
    Key key,
    @required bool isLoading,
  })  : _isLoading = isLoading,
        super(key: key);

  final bool _isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _isLoading ? 50.0 : 0,
      color: Colors.transparent,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ListViewHeader extends StatelessWidget {
  const ListViewHeader({
    Key key,
    @required int itemCount,
    @required int sectionIndex,
    @required EdgeInsetsGeometry padding,
  })  : _countItem = itemCount,
        _index = sectionIndex,
        _padding = padding,
        super(key: key);

  final int _countItem;
  final int _index;
  final EdgeInsetsGeometry _padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _padding,
      child: Text(
        "Section $_index ($_countItem)",
        style: const TextStyle(
          color: ProjectColor.black,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
