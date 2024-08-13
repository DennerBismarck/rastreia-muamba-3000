import 'package:flutter/material.dart';
import 'login_card.dart';
import 'signup_card.dart';

class TelaUm extends StatelessWidget {
  const TelaUm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Login'),
                Tab(text: 'Registrar'),
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
