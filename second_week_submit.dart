import 'dart:io';
import 'dart:math';

class Character {
  final String name;
  int health;
  int attack;
  final int baseAttack; // 기본 공격력 저장
  final int defense;
  bool hasUsedItem = false; // 아이템 사용 여부

  Character(this.name, this.health, this.attack, this.defense)
      : baseAttack = attack; // 기본 공격력 초기화

  void attackMonster(Monster monster) {
    int damage = max(0, attack - monster.defense);
    monster.health -= damage;
    print('$name이(가) ${monster.name}에게 $damage의 데미지를 입혔습니다!');
  }

  void defend() {
    health += 5;
    print('$name이(가) 방어 태세를 취하고 체력을 5 회복했습니다.');
  }

  void useItem() {
    if (!hasUsedItem) {
      attack = baseAttack * 2; // 공격력 2배로 증가
      hasUsedItem = true;
      print('$name이(가) 특수 아이템을 사용하여 이번 턴의 공격력이 2배가 됩니다!');
    } else {
      print('이미 아이템을 사용했습니다!');
    }
  }

  void resetAttack() {
    if (hasUsedItem) {
      attack = baseAttack; // 공격력 원래대로 복구
    }
  }

  void showStatus() {
    print('\n[$name의 상태]');
    print('체력: $health');
    print('공격력: $attack');
    print('방어력: $defense\n');
  }
}

class Monster {
  final String name;
  int health;
  final int attack;
  int defense = 0; // 이제 방어력이 변할 수 있음
  int turnCount = 0; // 턴 카운터

  Monster(this.name, this.health, int maxAttack, int characterDefense)
      : attack = max(maxAttack, characterDefense);

  void attackCharacter(Character character) {
    int damage = max(0, attack - character.defense);
    character.health -= damage;
    print('$name이(가) ${character.name}에게 $damage의 데미지를 입혔습니다!');

    // 3턴마다 방어력 증가
    turnCount++;
    if (turnCount % 3 == 0) {
      defense += 2;
      print('$name의 방어력이 증가했습니다! 현재 방어력: $defense');
    }
  }

  void showStatus() {
    print('\n[$name의 상태]');
    print('체력: $health');
    print('공격력: $attack');
    print('방어력: $defense\n');
  }
}

class Game {
  late Character character;
  List<Monster> monsters = [];
  int defeatedMonsters = 0;
  final Random random = Random();

  String getCharacterName() {
    while (true) {
      print('캐릭터 이름을 입력하세요:');
      String? input = stdin.readLineSync()?.trim();

      if (input == null || input.isEmpty) {
        print('이름을 반드시 입력해야 합니다.');
        continue;
      }

      if (!RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(input)) {
        print('이름은 한글과 영문만 사용할 수 있습니다.');
        continue;
      }

      return input;
    }
  }

  void applyHealthBonus() {
    // 30% 확률로 보너스 체력 부여
    if (random.nextInt(100) < 30) {
      character.health += 10;
      print('보너스 체력을 얻었습니다! 현재 체력: ${character.health}');
    }
  }

  void loadCharacterStats() {
    while (true) {
      try {
        final file = File('characters.txt');
        if (!file.existsSync()) {
          print('characters.txt 파일이 없습니다. 기본 스탯을 사용합니다.');
          character = Character(getCharacterName(), 50, 10, 5);
          return;
        }

        final contents = file.readAsStringSync().trim();
        final stats = contents.split(',');

        if (stats.length != 3) {
          throw FormatException('잘못된 캐릭터 데이터 형식입니다.');
        }

        int health = int.parse(stats[0]);
        int attack = int.parse(stats[1]);
        int defense = int.parse(stats[2]);

        if (health <= 0 || attack <= 0 || defense < 0) {
          throw FormatException('스탯은 0보다 커야 합니다.');
        }

        String name = getCharacterName();
        character = Character(name, health, attack, defense);
        applyHealthBonus(); // 보너스 체력 기회 부여
        return;
      } catch (e) {
        print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
        print('다시 시도하시겠습니까? (y/n)');
        if (stdin.readLineSync()?.toLowerCase() != 'y') {
          print('기본 스탯을 사용합니다.');
          character = Character(getCharacterName(), 50, 10, 5);
          return;
        }
      }
    }
  }

  void loadMonsterStats() {
    try {
      final file = File('monsters.txt');
      if (!file.existsSync()) {
        print('monsters.txt 파일이 없습니다. 기본 몬스터를 사용합니다.');
        monsters = [
          Monster('Goblin', 20, 15, character.defense),
          Monster('Orc', 30, 20, character.defense),
          Monster('Dragon', 50, 25, character.defense)
        ];
        return;
      }

      final lines = file.readAsLinesSync();

      for (var line in lines) {
        final stats = line.split(',');
        if (stats.length != 3) continue;

        try {
          String name = stats[0].trim();
          int health = int.parse(stats[1]);
          int maxAttack = int.parse(stats[2]);

          if (health <= 0 || maxAttack <= 0) continue;

          monsters.add(Monster(name, health, maxAttack, character.defense));
        } catch (e) {
          print('몬스터 데이터 처리 중 오류 발생: $e');
          continue;
        }
      }

      if (monsters.isEmpty) {
        throw FormatException('유효한 몬스터 데이터가 없습니다.');
      }
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      print('기본 몬스터를 사용합니다.');
      monsters = [
        Monster('Goblin', 20, 15, character.defense),
        Monster('Orc', 30, 20, character.defense),
        Monster('Dragon', 50, 25, character.defense)
      ];
    }
  }

  Monster getRandomMonster() {
    int index = random.nextInt(monsters.length);
    return monsters[index];
  }

  bool battle() {
    Monster currentMonster = getRandomMonster();
    print('\n${currentMonster.name}와(과)의 전투가 시작되었습니다!');

    while (true) {
      character.showStatus();
      currentMonster.showStatus();

      print('\n행동을 선택하세요:');
      print('1. 공격하기');
      print('2. 방어하기');
      if (!character.hasUsedItem) {
        print('3. 아이템 사용하기');
      }

      String? input = stdin.readLineSync()?.trim();

      switch (input) {
        case '1':
          character.attackMonster(currentMonster);
          break;
        case '2':
          character.defend();
          break;
        case '3':
          if (!character.hasUsedItem) {
            character.useItem();
            character.attackMonster(currentMonster);
          } else {
            print('잘못된 입력입니다.');
            continue;
          }
          break;
        default:
          print('잘못된 입력입니다.');
          continue;
      }

      // 몬스터 처치 확인
      if (currentMonster.health <= 0) {
        print('\n${currentMonster.name}을(를) 물리쳤습니다!');
        monsters.remove(currentMonster);
        defeatedMonsters++;
        character.resetAttack(); // 아이템 효과 초기화
        return true;
      }

      currentMonster.attackCharacter(character);
      character.resetAttack(); // 아이템 효과 초기화

      if (character.health <= 0) {
        print('\n${character.name}이(가) 쓰러졌습니다...');
        return false;
      }
    }
  }

  void saveResult(bool isVictory) {
    print('\n결과를 저장하시겠습니까? (y/n)');
    String? input = stdin.readLineSync()?.toLowerCase().trim();

    if (input == 'y') {
      try {
        final file = File('result.txt');
        final result = '''
게임 결과:
캐릭터 이름: ${character.name}
남은 체력: ${character.health}
결과: ${isVictory ? '승리' : '패배'}
물리친 몬스터 수: $defeatedMonsters
''';
        file.writeAsStringSync(result);
        print('결과가 저장되었습니다.');
      } catch (e) {
        print('결과 저장에 실패했습니다: $e');
      }
    }
  }

  void startGame() {
    print('=== RPG 게임 시작 ===');
    loadCharacterStats();
    loadMonsterStats();

    if (monsters.isEmpty) {
      print('게임을 시작할 수 없습니다: 몬스터가 없습니다.');
      return;
    }

    bool isVictory = false;
    while (character.health > 0 && monsters.isNotEmpty) {
      if (!battle()) break;

      if (monsters.isEmpty) {
        isVictory = true;
        print('\n모든 몬스터를 물리쳤습니다! 게임에서 승리했습니다!');
        break;
      }

      print('\n다음 몬스터와 대결하시겠습니까? (y/n)');
      String? input = stdin.readLineSync()?.toLowerCase().trim();
      if (input != 'y') break;
    }

    saveResult(isVictory);
    print('\n게임이 종료되었습니다.');
  }
}

void main() {
  Game game = Game();
  game.startGame();
}
