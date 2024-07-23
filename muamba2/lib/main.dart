import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:muamba2/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:muamba2/firebase_options.dart';
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';
import 'package:get/get.dart';

enum TableStatus { idle, loading, ready, error }

class ThemeController extends GetxController {
  ThemeData get themeData =>
      Get.isDarkMode ? ThemeData.dark() : ThemeData.light();
}

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'pt_BR': {
      'screen': 'Tela',
      'home': 'Um',
      'two': 'Dois',
      'three': 'Três',
      'screen_one': 'Tela Um',
      'screen_two': 'Tela Dois',
      'screen_three': 'Tela Três',
      'back': 'Voltar',
    },
    'en_US': {
      'screen': 'Screen',
      'home': 'One',
      'two': 'Two',
      'three': 'Three',
      'screen_one': 'Screen One',
      'screen_two': 'Screen Two',
      'screen_three': 'Screen Three',
      'back': 'Back',
    },
    'es_ES': {
      'screen': 'Pantalla',
      'home': 'Uno',
      'two': 'Dos',
      'three': 'Tres',
      'screen_one': 'Pantalla Uno',
      'screen_two': 'Pantalla Dos',
      'screen_three': 'Pantalla Tres',
      'back': 'Volver',
    }
  };
}

class DataService {
  final ValueNotifier<Map<String, dynamic>> tableStateNotifier =
  ValueNotifier({'status': TableStatus.idle, 'dataObjects': []});

  void carregar(index, String code) {
    final funcoes = [
      carregarRastreio(code),
    ];
    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': []
    };
    funcoes[index];
  }

  void carregarRastreio(String code) async {
    const user = 'guilherme.medeiros.706@ufrn.edu.br';
    const token =
        '2fdf7f9a5561535d82f7157c30075e21577f17b3b50b2107cff71a7f644eb75c';
    try {
      var rastreioUri = Uri(
        scheme: 'https',
        host: 'api.linketrack.com',
        path: 'track/json',
        queryParameters: {'codigo': code, 'token': token, 'user': user},
      );
      var jsonString = await http.read(rastreioUri);
      var trackJson = jsonDecode(jsonString);
      tableStateNotifier.value = {
        'status': TableStatus.ready,
        'dataObjects': trackJson,
        'propertyNames': ["host", "eventos", "data", "hora", "local", "status"],
      };
    } catch (error) {
      tableStateNotifier.value = {
        'status': TableStatus.error,
      };
    }
  }
}

final dataService = DataService();

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:  DefaultFirebaseOptions.currentPlatform,);
  MyApp app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      initialRoute: '/start',
      getPages: [
        GetPage(name: '/start', page: () => TelaUm()),
        GetPage(name: '/fasttrack', page: () => FastTrack()),
      ],
      translations: Messages(),
      locale: Get.deviceLocale,
      builder: (context, child) {
        return GetBuilder<ThemeController>(
          init: ThemeController(),
          builder: (themeController) {
            return MaterialApp(
              theme: themeController.themeData,
              darkTheme: ThemeData.dark(),
              home: child,
            );
          },
        );
      },
    );
  }
}

class TelaUm extends StatelessWidget {
  TelaUm();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Login'),
                Tab(text: 'Signup'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              LoginCard(),
              SignupCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class NewNavBar extends HookWidget {
  @override
  Widget build(BuildContext context) {
    var routes = ['/one', '/two', '/three'];

    return BottomNavigationBar(
      onTap: (index) => Get.toNamed(routes[index]),
      items: const [
        BottomNavigationBarItem(
          label: ' ',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: ' ',
          icon: Icon(Icons.looks_two),
        ),
        BottomNavigationBarItem(
          label: ' ',
          icon: Icon(Icons.looks_3),
        ),
      ],
    );
  }
}

class NewAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String nometela;

  NewAppBar({required this.nometela});

  @override
  _NewAppBarState createState() => _NewAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _NewAppBarState extends State<NewAppBar> {
  void _onSelected(Locale value) {
    setState(() {
      Get.updateLocale(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.nometela),
      actions: [
        PopupMenuButton(
          onSelected: _onSelected,
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: Locale('pt', 'BR'),
              child: Text('Português'),
            ),
            PopupMenuItem(
              value: Locale('en', 'US'),
              child: Text('Inglês'),
            ),
            PopupMenuItem(
              value: Locale('es', 'ES'),
              child: Text('Espanhol'),
            ),
          ],
        ),
      ],
    );
  }
}

class LoginCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle login logic here
                },
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed("/fasttrack");
                },
                child: Text('Fast Tracking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupCard extends StatelessWidget {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                controller: _emailController,
              )
              ,
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                controller: _passwordController,
                obscureText: true

              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _signUp();
                  // Handle signup logic here
                },
                child: Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async{
    String email = _emailController.text; 
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if(user != null){
      print("User succesfully created");
    }else{
      print("Some error happened");
    }
  }
}

class FastTrack extends StatelessWidget {
  final TextEditingController _codigoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewAppBar(nometela: "Rastreio Rápido"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _codigoController,
                  decoration: InputDecoration(labelText: 'Código de Rastreio'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    dataService.carregar(1, _codigoController.text);
                  },
                  child: Text("Procurar"),
                ),
              ),
              SingleChildScrollView(
                child: ValueListenableBuilder(
                    valueListenable: dataService.tableStateNotifier,
                    builder: (_, value, __) {
                      switch (value['status']) {
                        case TableStatus.idle:
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: 'https://i.imgur.com/zVkjVgc.png',
                                  height: 300.0,
                                  width: 300.0,
                                ),
                              ),
                              Text("Coloque um código para rastreio..."),
                            ],
                          );
                        case TableStatus.loading:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        case TableStatus.error:
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Ocorreu um erro ao carregar os dados."),
                                ElevatedButton(
                                  onPressed: () {
                                    dataService.carregar(
                                        1, _codigoController.text);
                                  },
                                  child: Text("Tentar Novamente"),
                                ),
                              ],
                            ),
                          );
                        case TableStatus.ready:
                          return RastreioWidget(data: value['dataObjects']);
                      }
                      return Text("Gambiarra.");
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RastreioWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  RastreioWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    List eventos = data['eventos'];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: eventos.length,
      itemBuilder: (context, index) {
        var evento = eventos[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: ListTile(
            title: Text(evento['status']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Data: ${evento['data']}"),
                Text("Hora: ${evento['hora']}"),
                Text("Local: ${evento['local']}"),
                ...evento['subStatus']
                    .map<Widget>((subStatus) => Text(subStatus))
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}