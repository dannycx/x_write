import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String msg;
  final String firstBtnText;
  final String secondBtnText;
  final String thirdBtnText;
  final VoidCallback onConfirm;

  const ConfirmDialog(
      {Key? key,
      required this.title,
      required this.msg,
      required this.onConfirm,
      this.firstBtnText = '取消',
      this.secondBtnText = '取消',
      this.thirdBtnText = '确认'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      elevation: 2,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildTitle(),
            const SizedBox(
              height: 10,
            ),
            _buildMessage(),
            const SizedBox(
              height: 20,
            ),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  _buildTitle() {
    return Container(
      alignment: Alignment.center,
      width: 220,
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.warning_amber,
            color: Colors.orange,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          )
        ],
      ),
    );
  }

  _buildMessage() {
    return Container(
      alignment: Alignment.center,
      width: 440,
      child: Row(
        children: <Widget>[
          Text(
            msg,
            style: const TextStyle(fontSize: 18, color: Color.fromARGB(255, 153, 153, 153)),
          )
        ],
      ),
    );
  }

  _buildButtons(BuildContext context) {
    return Container(
      width: 440,
      alignment: Alignment.centerRight,
      child: Wrap(
        alignment: WrapAlignment.end,
        children: <Widget>[
          OutlinedButton(
            onPressed: _notSave,
            child: Text(
              secondBtnText,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          OutlinedButton(
            onPressed: _save,
            child: Text(
              thirdBtnText,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _firstBtn() {
    if (firstBtnText.isEmpty) {
      return null;
    } else {
      return Row(
        children: [
          OutlinedButton(
            onPressed: _cancel,
            child: Text(
              firstBtnText,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      );
    }
  }

  void _cancel() {}

  void _notSave() {}

  void _save() {
    onConfirm.call();
  }
}
