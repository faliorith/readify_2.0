import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final List<String> favoriteBooks;
  final Map<String, int> readingProgress;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.favoriteBooks = const [],
    this.readingProgress = const {},
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'],
      favoriteBooks: List<String>.from(data['favoriteBooks'] ?? []),
      readingProgress: Map<String, int>.from(data['readingProgress'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'favoriteBooks': favoriteBooks,
      'readingProgress': readingProgress,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    List<String>? favoriteBooks,
    Map<String, int>? readingProgress,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      favoriteBooks: favoriteBooks ?? this.favoriteBooks,
      readingProgress: readingProgress ?? this.readingProgress,
    );
  }

  @override
  List<Object?> get props => [id, email, name, photoUrl, favoriteBooks, readingProgress];
} 