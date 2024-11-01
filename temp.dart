/*
//1
    if (input == '1') {
      for (var product in Product_List.entries) {
        print('${product.key} / ${product.value}원');
      }
    } else {
      print('유효하지 않은 입력입니다.');
    }
  }

//2
  void addToCart() {
    print(
        '[1] 상품 목록 보기 / [2] 장바구니에 담기 / [3] 장바구니에 담긴 상품의 총 가격 보기 / [4] 프로그램 종료');
    String? input = stdin.readLineSync();
  }

//3
  void viewPrice() {
    print(
        '[1] 상품 목록 보기 / [2] 장바구니에 담기 / [3] 장바구니에 담긴 상품의 총 가격 보기 / [4] 프로그램 종료');
    String? input = stdin.readLineSync();

//4
  void endshopping() {
    print('[1] 상품 목록 보기 / [2] 장바구니에 담기 / [3] 장바구니에 담긴 상품의 총 가격 보기 / [4] 프로그램 종료');
    String? input = stdin.readLineSync();

    while (input == 4);
      print('이용해 주셔서 감사합니다 ~ 안녕히 가세요 !');
  }


}


import 'dart:io';

void main() {
  Map<String, int> Product_List = {'신발': 50000, '니트': 70000, '코트': 150000, '가방' : 300000};

  print('상품 목록을 보려면 1을 입력하세요:');
  String? input = stdin.readLineSync();

  if (input == '1') {
    for (var product in Product_List.entries) {
      print('${product.key} / ${product.value}원');
    }
  } else {
    print('유효하지 않은 입력입니다.');
  }
}

입력값이 올바르지 않아요 !
입력값이 올바르지 않아요 !
0개보다 많은 개수의 상품만 담을 수 있어요 !
장바구니에 상품이 담겼어요 !

*/