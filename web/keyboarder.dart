part of game;

class Keyboarder {

  Set keyState = new Set();
  Map KEYS = { 'LEFT': 37, 'RIGHT': 39, 'S': 83 };

  Keyboarder() {
    window.onKeyDown.listen(_onKeyDown);
    window.onKeyUp.listen(_onKeyUp);
  }

  _onKeyDown(KeyboardEvent e) {
    keyState.add(e.keyCode);
  }

  _onKeyUp(KeyboardEvent e) {
    keyState.remove(e.keyCode);
  }

  bool isDown(keyCode) {
    return keyState.contains(keyCode);
  }

  bool isDownByName(String keyName) {
    return isDown(KEYS[keyName]);
  }

}
