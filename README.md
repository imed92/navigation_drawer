# Drawer Auth - Architecture MVVM

Ici on utilise le **pattern MVVM** (Model-View-ViewModel) avec navigation par drawer vers différentes pages.

## Table des matières

1. [Architecture](#architecture)
2. [Structure du projet](#structure-du-projet)
3. [Explication du code](#explication-du-code)
4. [Installation et utilisation](#installation-et-utilisation)

## Architecture

Le projet utilise le pattern **MVVM** qui sépare l'application en trois couches :

```
┌─────────────────┐
│     Views       │  ← Pages Flutter (UI)
├─────────────────┤
│   ViewModels    │  ← Logique métier et gestion d'état
├─────────────────┤
│     Models      │  ← Données et entités
└─────────────────┘
```

### Avantages du MVVM :
- **Séparation des responsabilités** - La UI est découpée de la logique
- **Réutilisabilité** - Les ViewModels peuvent être utilisés dans plusieurs vues
- **Testabilité** - Facile de tester la logique indépendamment de l'UI
- **Maintenabilité** - Code organisé et facile à modifier

## Structure du projet

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── views/
│   ├── home_page.dart       # Page d'accueil
│   └── second_page.dart     # Deuxième page
├── viewmodels/
│   └── home_viewmodel.dart  # ViewModel pour la page d'accueil
└── widgets/
    └── app_drawer.dart      # Drawer réutilisable
```

## Explication du code

### 1. **main.dart** - Point d'entrée

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drawer_auth/views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawer Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
```

**Explication :**
- `MaterialApp` configure l'application Flutter
- `home: HomePage()` définit la page d'accueil
- Tout le code du drawer et des pages a été retiré pour garder ce fichier **léger et lisible**

---

### 2. **home_viewmodel.dart** - Gestion d'état

```dart
import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier {
  String _title = 'Accueil';

  String get title => _title;

  void setTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  void resetTitle() {
    _title = 'Accueil';
    notifyListeners();
  }
}
```

**Explication :**
- `extends ChangeNotifier` - Permet de notifier les widgets quand l'état change
- `_title` - Variable privée contenant l'état
- `get title` - Getter pour accéder au titre (immuable)
- `setTitle()` - Modifie le titre et prévient les listeners
- `notifyListeners()` - Signal à Flutter de reconstruire les widgets dépendants

**Utilité :** Le ViewModel centralise la logique métier et l'état, séparé de l'UI.

---

### 3. **home_page.dart** - Page d'accueil

```dart
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
```

**Explication :**
- **HomePage** - Widget wrapper qui crée et fournit le ViewModel via Provider
- **HomePageContent** - Widget qui consomme le ViewModel
- `ChangeNotifierProvider` - Rend le ViewModel disponible aux descendants
- `Provider.of<HomeViewModel>(context)` - Accède au ViewModel
- `appBar: AppBar(title: Text(viewModel.title))` - Le titre vient du ViewModel
- `drawer: AppDrawer()` - Le drawer est réutilisable sur toutes les pages

**Avantage :** La page peut maintenant facilement accéder et modifier l'état du ViewModel.

---

### 4. **second_page.dart** - Deuxième page

```dart
import 'package:flutter/material.dart';
import 'package:drawer_auth/widgets/app_drawer.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deuxième Page'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ceci est la deuxième page'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Explication :**
- Page simple et indépendante
- `drawer: AppDrawer()` - Le même drawer que la page d'accueil
- Bouton de retour qui utilise `Navigator.pop(context)`

---

### 5. **app_drawer.dart** - Drawer réutilisable

```dart
import 'package:flutter/material.dart';
import 'package:drawer_auth/views/second_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Accueil'),
            onTap: () {
              Navigator.pop(context); // Ferme le drawer
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          ListTile(
            leading: Icon(Icons.pages),
            title: Text('Deuxième Page'),
            onTap: () {
              Navigator.pop(context); // Ferme le drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

**Explication :**

#### Accueil
```dart
onTap: () {
  Navigator.pop(context);              // Ferme le drawer
  Navigator.popUntil(context, (route) => route.isFirst); // Revient à la page 1
}
```
- `Navigator.pop(context)` - Ferme le drawer
- `Navigator.popUntil()` - Dépile toutes les routes jusqu'à la première

#### Deuxième Page
```dart
onTap: () {
  Navigator.pop(context); // Ferme le drawer
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SecondPage()),
  );
}
```
- `Navigator.pop(context)` - Ferme le drawer
- `Navigator.push()` - Navigue vers une nouvelle page (vraie navigation)

**Clé du projet :** Le drawer est un **composant indépendant** réutilisable partout !

---

## Installation et utilisation

### 1. Dépendances requises

```bash
flutter pub add provider
```

### 2. Installation

```bash
flutter pub get
```

### 3. Lancer l'application

```bash
flutter run -d chrome    # Pour le web
```

---

## Flux de navigation

```
HomePage (Accueil)
    ↓
  Drawer ← Utilisateur clique sur un item
    ↓
Deux options :
  1. "Accueil" → Ferme le drawer + Revient à la page 1
  2. "Deuxième Page" → Ferme le drawer + Navigue vers SecondPage
```

---

## Points clés à retenir

| Concept | Explication |
|---------|-------------|
| **MVVM** | Sépare la logique (ViewModel) de l'interface (View) |
| **Provider** | Gère l'état de manière réactive |
| **ChangeNotifier** | Notifie les widgets quand l'état change |
| **Drawer réutilisable** | Même composant utilisé sur plusieurs pages |
| **Navigation complète** | Chaque item du drawer mène à une vraie page |

---

## Notes

- Le **ViewModel** n'est créé que pour `HomePage` car c'est la seule qui en a besoin
- Vous pouvez créer d'autres ViewModels pour d'autres pages si nécessaire
- Le drawer est totalement découplé des pages spécifiques
