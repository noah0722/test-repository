import 'dart:io';

class Product {
  String name;
  int price;
  Product(this.name, this.price);
}

class ShoppingMall {
  List<Product> productList;
  Map<String, int> cart = {};
  int totalCost = 0;

  ShoppingMall(this.productList);

  static void showMenu() {
    print(
        '[1] 상품 목록 보기 / [2] 장바구니에 담기 / [3] 장바구니에 담긴 상품의 총 가격 보기 / [4] 프로그램 종료 / [6] 장바구니 초기화');
  }

  void showProducts() {
    for (var i = 0; i < productList.length; i++) {
      print('${i + 1}. ${productList[i].name} / ${productList[i].price}원');
    }
  }

  void addToCart() {
    showProducts();
    print('상품 번호를 입력하세요 (1-5):');

    try {
      String? input = stdin.readLineSync();
      int productIndex = int.parse(input!) - 1;

      if (productIndex < 0 || productIndex >= productList.length) {
        print('올바른 상품 번호를 입력해주세요 (1-5)!');
        return;
      }

      Product selectedProduct = productList[productIndex];
      print('선택한 상품: ${selectedProduct.name}');

      print('상품 개수를 입력하세요:');
      String? quantityInput = stdin.readLineSync();

      try {
        int quantity = int.parse(quantityInput ?? '');
        if (quantity <= 0) {
          print('0개보다 많은 개수의 상품만 담을 수 있어요 !');
          return;
        }

        cart[selectedProduct.name] =
            (cart[selectedProduct.name] ?? 0) + quantity;
        totalCost += selectedProduct.price * quantity;
        print('장바구니에 상품이 담겼어요 !');
      } catch (e) {
        print('올바른 숫자를 입력해주세요 !');
      }
    } catch (e) {
      print('올바른 상품 번호를 입력해주세요 !');
    }
  }

  void showTotal() {
    if (cart.isEmpty) {
      print('장바구니에 담긴 상품이 없습니다.');
    } else {
      // cart의 키(상품 이름)들을 List로 변환하여 join
      List<String> cartItems = cart.keys.toList();
      String itemsList = cartItems.join(', ');
      print('장바구니에 ${itemsList}가 담겨있네요. 총 ${totalCost}원 입니다!');
    }
  }

  bool checkIfLeaving() {
    print('정말 종료하시겠습니까? (5: 종료 / 다른 숫자: 계속)');
    String? input = stdin.readLineSync();

    try {
      if (input == '5') {
        print('이용해 주셔서 감사합니다 ~ 안녕히 가세요!');
        return true;
      } else {
        print('종료하지 않습니다.');
        return false;
      }
    } catch (e) {
      print('올바른 입력이 아닙니다. 종료하지 않습니다.');
      return false;
    }
  }

  void cartReset() {
    if (totalCost == 0) {
      print('이미 장바구니가 비어있습니다.');
    } else {
      print('장바구니를 초기화합니다.');
      cart.clear();
      totalCost = 0;
      print('장바구니가 초기화되었습니다.');
    }
  }
}

void main() {
  var products = [
    Product('셔츠', 45000),
    Product('원피스', 30000),
    Product('반팔티', 35000),
    Product('반바지', 38000),
    Product('양말', 5000)
  ];

  ShoppingMall mall = ShoppingMall(products);
  bool isRunning = true;

  while (isRunning) {
    ShoppingMall.showMenu();
    String? input = stdin.readLineSync();
    switch (input) {
      case '1':
        mall.showProducts();
        break;
      case '2':
        mall.addToCart();
        break;
      case '3':
        mall.showTotal();
        break;
      case '4':
        isRunning = !mall.checkIfLeaving();
        break;
      case '6':
        mall.cartReset();
        break;
      default:
        print('지원하지 않는 기능입니다 ! 다시 시도해 주세요 ..');
    }
  }
}
