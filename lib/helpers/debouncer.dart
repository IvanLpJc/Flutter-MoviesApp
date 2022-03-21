/**
 * *Esto es un debouncer que devolverá en este caso un Stream.
 * * Básicamente lo que hace es estar cogiendo datos hasta un momento 
 * * que nosotros establecemos (como dejar de teclear en un input, por ejemplo)
 */

import 'dart:async';
// Creditos
// https://stackoverflow.com/a/52922130/7834829

class Debouncer<T> {
  Debouncer(
      {required this.duration,
      //i Es el método a disparar cuando tenga un valor
      this.onValue});
  // i Cantidad de tiempo a esperar
  final Duration duration;

  void Function(T value)? onValue;

  T? _value;
  Timer? _timer;

  T get value => _value!;

  set value(T val) {
    _value = val;
    /**
     * i Este valor cancela el timer cuando llega un valor
     * i si el timer termina, entonces llama a la función onValue
     */
    _timer?.cancel();
    _timer = Timer(duration, () => onValue!(_value!));
  }
}
