import 'dart:io';

class shoppingMall {
  Map<String, int> Product_List = {
    '신발': 50000,
    '니트': 70000,
    '코트': 150000,
    '가방': 300000,
    '수트': 1000000
  };

// #0 메뉴 출력
  static void showMenu() {
    print(
        '[1] 상품 목록 보기 / [2] 장바구니에 담기 / [3] 장바구니에 담긴 상품의 총 가격 보기 / [4] 프로그램 종료');
  }

// [1] 상품 목록 보기
  void showProducts() {
    for (var product in Product_List.entries) {
      print('${product.key} / ${product.value}원');
    }
  }

// [2] 장바구니에 담기
  void addToCart() {}

// [3] 장바구니에 담긴 상품의 총 가격 보기
  void showTotal() {}

// [4] 프로그램 종료

  void main() {
    shoppingMall.showMenu;
    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        shoppingMall.showProducts();
        break;
      case '2':
        shoppingMall.addToCart();
    }
  }
}
