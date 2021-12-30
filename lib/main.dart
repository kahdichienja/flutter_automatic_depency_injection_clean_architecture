import 'package:flutter/material.dart';
import 'data/model/response/test_api_freezed_model.dart';
import 'di_container.dart' as di;
import 'package:provider/provider.dart';

import 'provider/api_test_provider_demo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  runApp(
    MultiProvider(
      child: MyApp(),
      providers: [
        ChangeNotifierProvider(
            create: (context) => di.sl<APIIntegrationDemoProvider>()),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Provider.of<APIIntegrationDemoProvider>(context, listen: false)
        .getUsers(context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  Future<void> _loadData(BuildContext context) async 

  => await Provider.of<APIIntegrationDemoProvider>(context, listen: false)
        .getUsers(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadData(context),
        child: Consumer<APIIntegrationDemoProvider>(
          builder: (BuildContext context, provider, Widget? child) =>
              provider.isloading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : provider.testAPIUserModel.length > 0
                      ? SingleChildScrollView(
                          child: Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    provider.testAPIUserModel.length, (index) {
                                  TestAPIUserModel user =
                                      provider.testAPIUserModel[index];
                                  return Card(
                                    child: ListTile(
                                      onTap: () => provider.getUser(user.id!),
                                      title: Text(user.name!),
                                      subtitle: Text(user.company!.name!),
                                      trailing: Text(user.phone!),
                                    ),
                                  );
                                })),
                          ),
                        )
                      : Center(child: Text("No data")),
        ),
      ),
    );
  }
}
