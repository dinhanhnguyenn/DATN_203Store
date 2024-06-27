class Product {
  String product_id;
  String image;
  String name;
  String quantity;
  String price;
  String category_id;
  String description;
  
  Product(
    {
      required this.product_id,
      required this.name,
      required this.image,
      required this.price,
      required this.quantity,
      required this.description,
      required this.category_id
    }
  );
}
