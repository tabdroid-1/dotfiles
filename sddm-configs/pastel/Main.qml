import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtMultimedia 5.0
import SddmComponents 2.0

import "components"

Item {
    id: root

    height: Screen.height
    width: Screen.width

//    AnimatedImage {
//        id: background 
//        source: "backgrounds/background.gif"
//        paused: false;
//        anchors.fill: parent
//        height: parent.height
//        width: parent.width
//        smooth: true
//        visible: true 
//    }

    Image {
        id: background

        anchors.fill: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectCrop

        source: config.Background

        asynchronous: false
        cache: true
        mipmap: true
        clip: true
    }

    Item {
        id: contentPanel

        anchors {
            fill: parent
            topMargin: config.Padding
            rightMargin: config.Padding
            bottomMargin:config.Padding
            leftMargin: config.Padding
        }

        DateTimePanel {
            id: dateTimePanel

            anchors {
                top: parent.top
                right: parent.right
            }
        }

        LoginPanel {
            id: loginPanel

            anchors.fill: parent
        }
    }
}
