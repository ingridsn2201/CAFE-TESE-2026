import '../constants/firestore_paths.dart';

enum OrderStatus {
  recibido,
  enPreparacion,
  listo,
  entregado,
  cancelado;

  /// Valor exacto que se guarda en Cloud Firestore
  String get firestoreValue {
    switch (this) {
      case OrderStatus.recibido:
        return FirestorePaths.estadoRecibido;
      case OrderStatus.enPreparacion:
        return FirestorePaths.estadoEnPreparacion;
      case OrderStatus.listo:
        return FirestorePaths.estadoListo;
      case OrderStatus.entregado:
        return FirestorePaths.estadoEntregado;
      case OrderStatus.cancelado:
        return FirestorePaths.estadoCancelado;
    }
  }

  /// Texto legible para mostrar en la interfaz
  String get label {
    switch (this) {
      case OrderStatus.recibido:
        return 'Recibido';
      case OrderStatus.enPreparacion:
        return 'En preparación';
      case OrderStatus.listo:
        return 'Listo';
      case OrderStatus.entregado:
        return 'Entregado';
      case OrderStatus.cancelado:
        return 'Cancelado';
    }
  }

  /// Convierte el String de Firestore al enum OrderStatus
  static OrderStatus fromString(String value) {
    switch (value) {
      case FirestorePaths.estadoRecibido:
        return OrderStatus.recibido;
      case FirestorePaths.estadoEnPreparacion:
        return OrderStatus.enPreparacion;
      case FirestorePaths.estadoListo:
        return OrderStatus.listo;
      case FirestorePaths.estadoEntregado:
        return OrderStatus.entregado;
      case FirestorePaths.estadoCancelado:
        return OrderStatus.cancelado;
      default:
        return OrderStatus.recibido;
    }
  }

  /// Valida si la transición hacia [nextStatus] está permitida
  bool canTransitionTo(OrderStatus nextStatus) {
    if (this == OrderStatus.entregado || this == OrderStatus.cancelado) {
      return false; // Estados terminales
    }
    switch (this) {
      case OrderStatus.recibido:
        return nextStatus == OrderStatus.enPreparacion ||
            nextStatus == OrderStatus.cancelado;
      case OrderStatus.enPreparacion:
        return nextStatus == OrderStatus.listo ||
            nextStatus == OrderStatus.cancelado;
      case OrderStatus.listo:
        return nextStatus == OrderStatus.entregado ||
            nextStatus == OrderStatus.cancelado;
      default:
        return false;
    }
  }
}