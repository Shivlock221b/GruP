import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {

  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  static encryptAES(text) {
    final encrypted = encrypter.encrypt(text, iv: iv).base64;

    // print(encrypted.bytes);
    // print(encrypted.base16);
    // print(encrypted.base64);
    print("encrypted $encrypted");
    return encrypted;
  }

  static decryptAES(text) {
    encrypt.Encrypted encrypted = encrypt.Encrypted.fromBase64(text);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    print(decrypted);
    return decrypted;
  }
}