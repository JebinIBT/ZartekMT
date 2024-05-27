class Restaurant {
  String restaurantId;
  List<TableMenuList> tableMenuList;

  Restaurant({
    required this.restaurantId,
    required this.tableMenuList,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      restaurantId: json['restaurant_id'],
      tableMenuList: (json['table_menu_list'] as List)
          .map((item) => TableMenuList.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant_id': restaurantId,
      'table_menu_list': tableMenuList.map((item) => item.toJson()).toList(),
    };
  }
}

class TableMenuList {
  String menuCategory;
  String menuCategoryId;
  List<CategoryDish> categoryDishes;

  TableMenuList({
    required this.menuCategory,
    required this.menuCategoryId,
    required this.categoryDishes,
  });

  factory TableMenuList.fromJson(Map<String, dynamic> json) {
    return TableMenuList(
      menuCategory: json['menu_category'],
      menuCategoryId: json['menu_category_id'],
      categoryDishes: (json['category_dishes'] as List)
          .map((item) => CategoryDish.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_category': menuCategory,
      'menu_category_id': menuCategoryId,
      'category_dishes': categoryDishes.map((item) => item.toJson()).toList(),
    };
  }
}

class CategoryDish {
  String dishId;
  String dishName;
  String dishImage;
  String dishDescription;
  String nexturl;
  int dishType;
  double dishCalories;
  double dishPrice;
  List<AddonCat> addonCat;

  CategoryDish({
    required this.dishId,
    required this.dishName,
    required this.dishImage,
    required this.dishDescription,
    required this.nexturl,
    required this.dishType,
    required this.dishCalories,
    required this.dishPrice,
    required this.addonCat,
  });

  factory CategoryDish.fromJson(Map<String, dynamic> json) {
    return CategoryDish(
      dishId: json['dish_id'],
      dishName: json['dish_name'],
      dishImage: json['dish_image'],
      dishDescription: json['dish_description'],
      nexturl: json['nexturl'],
      dishType: json['dish_Type'],
      dishCalories: json['dish_calories'].toDouble(),
      dishPrice: json['dish_price'].toDouble(),
      addonCat: (json['addonCat'] as List)
          .map((item) => AddonCat.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dish_id': dishId,
      'dish_name': dishName,
      'dish_image': dishImage,
      'dish_description': dishDescription,
      'nexturl': nexturl,
      'dish_Type': dishType,
      'dish_calories': dishCalories,
      'dish_price': dishPrice,
      'addonCat': addonCat.map((item) => item.toJson()).toList(),
    };
  }
}

class AddonCat {
  String addonCategory;

  AddonCat({
    required this.addonCategory,
  });

  factory AddonCat.fromJson(Map<String, dynamic> json) {
    return AddonCat(
      addonCategory: json['addon_category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addon_category': addonCategory,
    };
  }
}
