class Product {
  String product_id;
  String image;
  String name;
  String price;
  String category_id;
  String description;
  String status;
  
  Product(
    {
      required this.product_id,
      required this.name,
      required this.image,
      required this.price,
      required this.description,
      required this.category_id,
      required this.status
    }
  );
}