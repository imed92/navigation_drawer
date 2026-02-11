import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drawer_auth/viewmodels/home_viewmodel.dart';
import 'package:drawer_auth/widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: HomePageContent(),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.title),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Bienvenue sur la page d\'accueil'),
      ),
    );
  }
}
