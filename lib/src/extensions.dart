import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Extension methods for [Listenable].
extension ListenableExtension on Listenable {
  /// Returns a merged Listenable instance that listens to both this and the
  ///  [other] Listenable instances.
  ///
  /// ```dart
  /// final notifier1 = ValueNotifier(0);
  /// final notifier2 = ValueNotifier(0);
  /// final merged = notifier1 + notifier2;
  ///
  /// merged.listen((value) => print(value));
  Listenable operator +(Listenable other) => Listenable.merge([this, other]);
}

/// Extension methods for [ValueNotifier].
extension ValueNotifierExtension<T> on ValueNotifier<T> {
  /// Sets the value of the ValueNotifier using callable class syntax.
  ///
  /// ```dart
  /// final notifier = ValueNotifier(0);
  /// notifier(1);
  /// ```
  ValueNotifier<T> call(T value) {
    this.value = value;
    return this;
  }

  /// Updates the value of the ValueNotifier using the provided update function
  ///
  /// ```dart
  /// final notifier = ValueNotifier(0);
  /// notifier.update((value) => value * 2);
  /// ```
  ValueNotifier<T> update(T Function(T) update) {
    value = update(value);
    return this;
  }

  /// Adds a [listener] to the ValueNotifier and returns a callback that can be
  /// used to remove the listener.
  ///
  /// If [fireImmediately] is set to true, the
  /// provided listener function is called immediately.
  VoidCallback listen(
    void Function(T) listener, {
    bool fireImmediately = false,
  }) {
    void handleListener() {
      listener(value);
    }

    void handleRemove() {
      removeListener(handleListener);
    }

    if (fireImmediately) handleListener();

    addListener(handleListener);

    return handleRemove;
  }

  /// Adds a listener to [other] ValueNotifier instance and updates the value
  /// of the current ValueNotifier whenever the [other] ValueNotifier changes.
  ///
  /// Returns a callback that can be used to remove the listener.
  ///
  /// If fireImmediately is set to true, the value of the current ValueNotifier
  ///  is updated immediately.
  VoidCallback listenTo(
    ValueNotifier<T> other, {
    bool fireImmediately = false,
  }) {
    return () => other.listen(
          (value) => this.value = value,
          fireImmediately: fireImmediately,
        );
  }
}
