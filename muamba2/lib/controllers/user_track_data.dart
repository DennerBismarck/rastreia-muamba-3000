import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

addTrackingCode(String code, String packetName) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    CollectionReference trackingCodes = FirebaseFirestore.instance
        .collection('users') 
        .doc(user.uid) 
        .collection('tracking_codes'); 
  
    await trackingCodes.add({
      'code': code,
      'name': packetName,
      'timestamp': FieldValue.serverTimestamp(),
    });


  } 
//NC792436076BR
  
}

Stream<QuerySnapshot> getTrackingCodes() {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tracking_codes')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  return Stream.empty();
}

Future<void> deleteTrackingCodeByCode(String trackingCode) async {
    User? user = FirebaseAuth.instance.currentUser;

  try {
    // Referência à coleção de códigos de rastreio do usuário
    CollectionReference trackingCodesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('tracking_codes');

    // Consultar o documento que possui o código de rastreio específico
    QuerySnapshot querySnapshot = await trackingCodesRef
        .where('code', isEqualTo: trackingCode)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assumindo que o código de rastreio é único, pegue o primeiro documento encontrado
      DocumentSnapshot docSnapshot = querySnapshot.docs.first;
      await docSnapshot.reference.delete();
      print('Documento deletado com sucesso.');
    } else {
      print('Nenhum documento encontrado com o código de rastreio fornecido.');
    }
  } catch (e) {
    print('Erro ao deletar documento: $e');
  }
}
