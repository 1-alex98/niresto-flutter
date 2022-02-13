
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:niresto_flutter/screens/widgets/participant_info.dart';
import 'package:niresto_flutter/screens/widgets/question_details.dart';
import 'package:niresto_flutter/screens/widgets/question_list.dart';
import 'package:niresto_flutter/services/authentication_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:get_it/get_it.dart';

class QuestionScreen extends StatefulWidget {
  final String subPageRoute;

  const QuestionScreen({Key? key, required this.subPageRoute}) : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final callback = Callback();
  var visibleSendButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(onParticipantInfo: _onParticipantInfo),
        floatingActionButton: Visibility(
          child: FloatingActionButton(
            onPressed: () {
              callback.onSend!();
              setState(() {
                visibleSendButton = false;
              });
            },
            backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            child: const Icon(Icons.send),
          ),
          visible: visibleSendButton,
        ),
        appBar: AppBar(
          title: const Text('Questions'),
        ),
        body: WillPopScope(
          child: Navigator(
            key: _navigatorKey,
            initialRoute: widget.subPageRoute,
            onGenerateRoute: _onGenerateRoute,
          ),
          onWillPop: () async {
            _navigatorKey.currentState!.maybePop();
            setState(() {
              visibleSendButton = false;
            });
            return false;
          },
        ),
    );
  }

  Future _onQuestionDetails(Question question) async{
    await _navigatorKey.currentState!.pushNamed("detail", arguments: question);
  }

  Future _onParticipantInfo() async{
    await _navigatorKey.currentState!.pushNamed("info");
  }

  Route? _onGenerateRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case "":
      case "list":
        page = QuestionList(onQuestionDetails: _onQuestionDetails);
        if(visibleSendButton){
          setState(() {
            visibleSendButton = false;
          });
        }
        break;
      case "detail":
        page = QuestionDetails(question: settings.arguments as Question, onSendCallBack: callback);
        setState(() {
          visibleSendButton = true;
        });
        break;
      case "info":
        page = const ParticipantInfo();
        setState(() {
          visibleSendButton = false;
        });
        break;
    }

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },

      settings: settings,
    );
  }
}

class NavDrawer extends StatelessWidget {
  Future Function() onParticipantInfo;

  NavDrawer({required this.onParticipantInfo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/logo.jpeg'))),
            child: null,
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              var instance = GetIt.instance<AuthenticationService>();
              await instance.logout();
              Navigator.of(context).pop();
              Navigator.popAndPushNamed(context, "/connection");
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('My id'),
            onTap: () async {
              onParticipantInfo();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}