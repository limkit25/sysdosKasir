import 'package:equatable/equatable.dart';

class Supplier extends Equatable {
  final int? id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? contactPerson;

  const Supplier({
    this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.contactPerson,
  });

  @override
  List<Object?> get props => [id, name, phone, email, address, contactPerson];
}
