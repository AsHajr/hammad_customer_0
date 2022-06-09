
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressModel{
  String id;
  String nickName;
  LatLng latLng;
  String city;
  String area;
  String street;
  String buildingNo;
  String floor;
  String additionalDirec;

  AddressModel(this.id,this.nickName, this.latLng, this.city, this.area,
      this.street, this.buildingNo, this.floor, this.additionalDirec);
}