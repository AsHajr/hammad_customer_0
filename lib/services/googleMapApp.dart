import 'package:url_launcher/url_launcher.dart';

class MapUtils {

  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/dir//Hammad+Water+-+حماد+للمياه+النقية,+An-Nahdah+St.+65,+Amman%E2%80%AD/@32.0019135,35.9557119,17z';
    try{
      await launch(googleUrl);
    }catch(e){
      print(e);
    }
  }
}