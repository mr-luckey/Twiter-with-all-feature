import 'package:flutter/material.dart';
import 'package:kronosss/Common/loading_view.dart';

class ProgressPage extends StatefulWidget {
  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  void initState() {
    super.initState();
    //timeOut();
  }

  void timeOut() async {
    await Future.delayed(Duration(seconds: 1));
    Navigator.canPop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: LoadingView(
          text: 'Actualizando datos...',
        ),
      ),
    );
  }
}
