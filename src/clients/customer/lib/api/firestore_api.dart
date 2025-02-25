import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../app/app.logger.dart';
import '../constants/app_keys.dart';
import '../exceptions/firestore_api_exception.dart';
import '../models/application_models.dart';

class FirestoreApi {
  final log = getLogger('FirestoreApi');

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection(UsersFirestoreKey);

  final CollectionReference regionsCollection = FirebaseFirestore.instance.collection(RegionsFirestoreKey);

  Future<void> createUser({required User user}) async {
    log.i('user:$user');

    try {
      final userDocument = usersCollection.doc(user.id);
      await userDocument.set(user.toJson());
      log.v('UserCreated at ${userDocument.path}');
    } catch (error) {
      throw FirestoreApiException(
        message: 'Failed to create new user',
        devDetails: '$error',
      );
    }
  }

  Future<User?> getUser({required String userId}) async {
    log.i('userId:$userId');

    if (userId.isNotEmpty) {
      final userDoc = await usersCollection.doc(userId).get();
      if (!userDoc.exists) {
        log.v('We have no user with id $userId in our database');
        return null;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      log.v('User found. Data: $userData');

      return User.fromJson(userData);
    } else {
      throw FirestoreApiException(message: 'Your userId passed in is empty. Please pass in a valid user if from your Firebase user.');
    }
  }

  /// Saves the address passed in to the backend for the user and also sets
  /// the default address if the user doesn't have one set.
  /// Returns true if no errors occured
  /// Returns false for any error at any part of the process
  Future<bool> saveAddress({
    required Address address,
    required User user,
  }) async {
    log.i('address:$address');

    try {
      final addressDoc = getAddressCollectionForUser(user.id).doc();
      final newAddressId = addressDoc.id;
      log.v('Address will be stored with id: $newAddressId');

      await addressDoc.set(
        address.copyWith(id: newAddressId).toJson(),
      );

      final hasDefaultAddress = user.hasAddress;

      log.v('Address save complete. hasDefaultAddress:$hasDefaultAddress');

      if (!hasDefaultAddress) {
        log.v('This user has no default address. We need to set the current one as default');

        await usersCollection.doc(user.id).set(
              user.copyWith(defaultAddress: newAddressId).toJson(),
            );
        log.v('User ${user.id} defaultAddress set to $newAddressId');
      }

      return true;
    } on Exception catch (e) {
      log.e('we could not save the users address. $e');
      return false;
    }
  }

  Future<bool> isCityServiced({required String city}) async {
    log.i('city:$city');
    final cityDocument = await regionsCollection.doc(city).get();
    return cityDocument.exists;
  }

  CollectionReference getAddressCollectionForUser(String userId) {
    return usersCollection.doc(userId).collection(AddressesFirestoreKey);
  }
}
