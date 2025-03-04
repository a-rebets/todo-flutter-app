import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase.g.dart';

@riverpod
FirebaseFirestore firestore(Ref<FirebaseFirestore> ref) =>
    FirebaseFirestore.instance;

@riverpod
FirebaseAuth auth(Ref<FirebaseAuth> ref) => FirebaseAuth.instance;
