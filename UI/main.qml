import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

ApplicationWindow {
  visible: true
  width: 541
  height: 600
  // x: screen.desktopAvailableWidth - width - 12
  // y: screen.desktopAvailableHeight - height - 48
  title: "Circuit Tracks SysEx Editor"

  // flags: Qt.FramelessWindowHint | Qt.Window

  property string currTime: "00:00:00"
  property var sysExIn //sysex file read from file by main.py
  property var sysExTemp: sysExIn //sysex file read from file by main.py
  property QtObject backend
  property var stringed: "" //string of hex file to print

  // function indexOfChild (item, child) {
  //   var ret = -1;
  //   if (item && child && "children" in item) {
  //     for (var idx = 0; ret < 0 && idx < item.children.length; idx++) {
  //       if (item.children [idx] === child) {
  //         ret = idx;
  //       }
  //     }
  //   }
  //   return ret;
  // }
  //
  // function prevSibling (item, child) {
  //   return (item.children [indexOfChild (item, child) -1] || null);
  // }
  //
  // function nextSibling (item, child) {
  //   return (item.children [indexOfChild (item, child) +1] || null);
  // }

  function swapTest(listIn) {
    var listOut = move(listIn, 213, 17, 247);
      hexReadoutText.text = convertList(listOut, stringed)
      // hexReadoutText.opacity = 0.5


  }

  function move(list, from, count, to) {
      var tempList = list//.slice();
      var args = [from > to ? to : to - count, 0];
      args.push.apply(args, tempList.splice(from, count));
      tempList.splice.apply(tempList, args);
      return tempList;
  }


  function convertList(listIn, stringIn) {
    stringIn = ""
    for (var x = 0; x < listIn.length; x++){
      if(x==0){
        stringIn += '<font color="#3c493f">'
      }
      if(x==213 || x==247 || x==281 || x==315){
        stringIn += '</font> <font color="#69353f">'
      }
      if(x==230 || x==264 || x==298 || x==332){
        stringIn += '</font> <font color="#914d76">'
      }
      if(x==349){
        stringIn += '</font> <font color="#3c493f">'
      }

      stringIn+= listIn[x].toString() + " "
    }
    stringIn += '</font>'
    return stringIn
  }

  Rectangle {
    anchors.fill: parent
    // Image {
    //     sourceSize.width: parent.width
    //     sourceSize.height: parent.height
    //     source: "./images/playas.jpg"
    //     fillMode: Image.PreserveAspectCrop
    // }
    Rectangle {
      id: mainBackground;
      anchors.fill: parent
      color: "#d8ebe5"
    }
    Rectangle {
      anchors.fill: parent
      id: mainElements
      color: "transparent"

      Button {
        x:12
        y:12
        text: "Show Hex File"
        // opacity: 0.5
        onClicked: hexReadoutRect.visible = true
      }


      Rectangle {
        anchors.fill: parent
        color: "#d8ebe5"
        id: hexReadoutRect
        visible: false
        Text {
          anchors {
            top: parent.top
            topMargin: 12
            left: parent.left
            leftMargin: 12
          }
          id: hexReadoutText
          width: 517
          text: convertList(sysExIn, stringed)
          wrapMode:Text.WordWrap
          font.pixelSize: 20
          color: "#777777"
          font.family: "Consolas"
        }

        RowLayout {
          id: hexButtonRow
          // anchors.fill: parent
          anchors {
            bottom: parent.bottom
            bottomMargin: 12
            left: parent.left
            // leftMargin: 12
            right: parent.right
          }
          spacing: 6

          Button {
            // anchors {
            //   bottom: parent.bottom
            //   bottomMargin: 12
            //   left: parent.left
            //   leftMargin: 12
            // }
            text: "Hide"
            onClicked: hexReadoutRect.visible = false
          }

          Button {
            // anchors {
            //   bottom: parent.bottom
            //   bottomMargin: 12
            //   left: parent.left
            //   leftMargin: 12
            // }
            text: "Swap"
            onClicked: swapTest(sysExTemp)
          }
        }

      } //end hex readout layer

    }

  } //end absolute env

  Connections {
    target: backend

    function onUpdated(msg) {
      currTime = msg;
      // body...
    }

  }





}
