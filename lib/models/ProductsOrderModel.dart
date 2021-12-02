class ProductsModel{
int gallons;
int package;
double price;

ProductsModel(this.gallons, this.package);

String getPrice(){
  price = gallons * 0.45 + package * 1 ;
  return price.toStringAsFixed(2);
}
String getTotalPrice(){
  price = gallons * 0.45 + package * 1 + 1;
  return price.toStringAsFixed(2);
}
}