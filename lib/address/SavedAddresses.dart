import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hammad_customer_0/address/EditAddress.dart';
import 'package:hammad_customer_0/components/addAddressButton.dart';
import 'package:hammad_customer_0/models/UserModel.dart';
import 'package:hammad_customer_0/services/checkLanguage.dart';
import 'package:hammad_customer_0/services/database.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:provider/provider.dart';

import 'GoogleMapPage.dart';
import 'package:hammad_customer_0/translations/locale_keys.g.dart';
import '../models/AddressModel.dart';

class SavedAddresses extends StatefulWidget {
  const SavedAddresses({Key key}) : super(key: key);

  @override
  _SavedAddressesState createState() => _SavedAddressesState();
}

class _SavedAddressesState extends State<SavedAddresses> {
  List<AddressModel> addresses;
  List<AddressCard> addressCards;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context,listen: false);
    final textDirection = getTextDir(context);
    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.addresses.tr()),
          actions: [
            TextButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoogleMapPage()));
              },
                child: Text(LocaleKeys.add.tr(),
                  style: TextStyle(color: Colors.black45,fontSize: 16),
                )
            ),
          ],
        ),
          body: StreamBuilder(
            stream: DatabaseService(context).getAddressesStream(user.id),
            builder: (context, snapshot) {
              addressCards = [];
              addresses = [];
              if(snapshot.hasData){
                addresses = snapshot.data as List<AddressModel>;
                addressCards.addAll(addresses.map((e) => AddressCard(address: e)));
                return ListView(children: addressCards,
                );
              }
              return addAddressButton(context);
            }
          ),
      ),
    );
  }
}
class AddressCard extends StatelessWidget {
  final AddressModel address;

  const AddressCard({Key key, this.address,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditAddress(address: address,)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('${address.nickName}(${address.area})', style:
              TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.grey[600]),),
              Text('${address.floor},${address.buildingNo},${address.street}',
                style:
                TextStyle(fontSize: 17.0, color: Colors.grey[800]),),
              Text('${address.additionalDirec}',
                style:
                TextStyle(fontSize: 17.0, color: Colors.grey[800]),),
              SizedBox(height: 10,),
              Divider(thickness: 2,height: 2,)
            ],
          ),
        ),
      ),
    );
  }
}

