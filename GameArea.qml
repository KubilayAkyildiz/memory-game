import QtQuick 2.0
import QtQuick.Layouts 1.3
import './js/GameUtils.js' as GameUtils

GridLayout {
  id: area
  anchors.fill: parent
  anchors.margins: 25
  columns: (width < height) ? 4 : Math.round(repeater.model / 4)
  rowSpacing: 5
  columnSpacing: 5

  property int imageCount: 10
  property int repeatCount: (repeater.model > imageCount)
                                ? repeater.model / imageCount : 1
  property variant imageIndexes: GameUtils.generateCardIndexes(
                                   imageCount, repeatCount)
  property int card1: -1
  property int card2: -1
  property int remaining: Math.round(repeater.model / 2)

  function cardClicked(index) {
    var card = repeater.itemAt(index);
    if (!card.flipped) {
      card.flipped = true;
      if (card1 === -1) {
        card1 = index;
      } else {
        card2 = index;
        area.enabled = false;
        delayTimer.start();
      }
    } else {
      card.flipped = false;
      card1 = -1;
    }
  }

  function validateCards() {
    var state = '';
    if (imageIndexes[card1] === imageIndexes[card2]) {
      state = 'remove';
      --remaining;
    }
    repeater.itemAt(card1).state = state;
    repeater.itemAt(card2).state = state;
    card1 = -1;
    card2 = -1;
    area.enabled = true;
    if (remaining === 0) {
      console.log('Game Over!');
    }
  }

  Timer {
    id: delayTimer
    interval: 1000
    onTriggered: area.validateCards()
  }

  Repeater {
    id: repeater
    model: 40

    Card {
      id: card
      backImageSource: 'qrc:/images/img_' + area.imageIndexes[index] + '.jpg'

      MouseArea {
        anchors.fill: parent
        onClicked: area.cardClicked(index)
      }
    }
  }
}
