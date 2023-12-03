import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x_write/model/net/api/search_image_api.dart';

class SearchImage extends StatefulWidget {
  const SearchImage({super.key});

  @override
  State<SearchImage> createState() => _SearchImageState();
}

class _SearchImageState extends State<SearchImage> {
  SearchImageApi imageApi = SearchImageApi();
  bool _loading = true;
  String? _searchKey = '';
  List<String> _searchResult = List.generate(10, (index) => "");

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _searchKeyFocusNode = FocusNode();
  bool _searchKeyHasFocus = false;

  @override
  void initState() {
    super.initState();
    // 监听焦点变化
    _searchKeyFocusNode.addListener(_handleSearchKeyFocusChange);

    // 监听文本变化
    _textEditingController.addListener(() {
      _searchKey = _textEditingController.text;
      print('_textEditingController text: $_searchKey');
      // _textEditingController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 100, 10),
                    child: TextField(
                      focusNode: _searchKeyFocusNode,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: _searchKeyHasFocus ? Colors.lightBlue[100] : Colors.grey[200],
                        border: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 31, 134, 235))),
                        hintText: '请输入',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.all(6), // 内边距
                      ),
                      // onChanged: (value) {}, // 文本变化
                      controller: _textEditingController, // 文本变化
                    ),
                  ),
                ),
                Positioned(
                    top: 10,
                    right: 10,
                    child: OutlinedButton(
                      onPressed: _searchImage,
                      child: const Text('Search'),
                    )),
              ],
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
            _imageWidget(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchKeyFocusNode.removeListener(_handleSearchKeyFocusChange);
    _searchKeyFocusNode.dispose();
    super.dispose();
  }

  // 处理输入框焦点变化
  void _handleSearchKeyFocusChange() {
    setState(() {
      _searchKeyHasFocus = _searchKeyFocusNode.hasFocus;
    });
  }

  void _loadData() async {
    _loading = true;
    setState(() {});
    _searchResult.clear();
    _searchResult = await imageApi.obtainImage(_searchKey!, 60);
    _searchResult.removeWhere((element) => element.isEmpty);
    _loading = false;
    setState(() {});
  }

  void _searchImage() {
    print('_searchImage: $_searchImage');
    if (_searchKey == null || _searchKey!.isEmpty) {
      return;
    }
    _loadData();
  }

  _imageWidget() {
    if (_loading) {
      return Container(
        height: 560,
        child: const Wrap(
          spacing: 10,
          alignment: WrapAlignment.center,
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CupertinoActivityIndicator(),
            Text(
              'loading...',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      );
    }
    return Container(
        child: Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 每行3列
                childAspectRatio: 1.0, // 显示区域宽高等比
                crossAxisSpacing: 5,
                mainAxisSpacing: 5),
            // shrinkWrap: true, // 问题：Vertical viewport was given unbounded height
            padding: const EdgeInsets.all(5),
            itemCount: _searchResult.length,
            itemBuilder: (context, index) {
              String path = _searchResult[index];
              print('_searchResult index: $index : $path');
              return Image.network(path);
            },
          ),
        )
    );
  }
}
