import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/screens/screens.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

// i Tenemos que iniciar primero el widget provider para que esté disponible en toda la app
// i por eso llamamos primero a AppState
// void main() => runApp(const AppState());
class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // i Aquí podemos añadir todos los provider
        // i que podamos necesitar a lo largo de la app
        ChangeNotifierProvider(
          create: (_) => MoviesProvider(),
          lazy: false,
        ),
        /**
         * i Por defecto, el provider es creado de manera perezosa, es decir, hasta qe
         * i que algún widget lo necesite, va a verificar si hay una instancia creada,
         * i si está creada la retorna y si no la crea
         * 
         * i Vamos a cambiar el comportamiento para que apenas se defina el movieProvider
         * i se ejecute el constructor para que de base toda la app tenga conocimiento del provider
         * i por eso ponemos el lazy: false
         * 
         */
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peliculas',
      debugShowCheckedModeBanner: false,
      initialRoute: '/initScreen',
      routes: {
        '/home': (_) => const HomeScreen(),
        '/detailsScreen': (_) => const DetailsScreen(),
        '/initScreen': (_) => const InitScreen(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          color: Colors.indigo,
        ),
      ),
    );
  }
}
