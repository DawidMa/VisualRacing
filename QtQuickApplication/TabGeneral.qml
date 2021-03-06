import QtQuick 2.0
import VRPlot 1.0
import QtQuick.Layouts 1.3

Rectangle {
    color: "#3e4244"

    VRPlotRPM {
        id: rpmPlot
        objectName: "rpmPlot"
        width: parent.width / 3
        height: parent.height * 0.5
        anchors.top: parent.top
        anchors.left: parent.left

        Component.onCompleted: init()

        function init(){
            rpmPlot.initCustomPlot();
            rpmPlot.setItsMaxRpm(6000);
        }

        Timer {
            interval: 20
            running: true
            repeat: true
            onTriggered: rpmPlot.pushData(vrData.getTimeInSeconds(), vrData.rpm, vrData.gear)
        }

        Connections {
            target: vrData
            onMaxRpmChanged: rpmPlot.setItsMaxRpm(vrData.maxRpm)
        }
    }

    ////////////////////////////////////////////////////////////////////////
    Rectangle {
        id: generalInfoTile
        width: parent.width * 0.25
        height: parent.height * 0.42
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 15

        color: "transparent"
        border.color: "#a7def9"

        Rectangle {
            id: revCounterContainer
            width: parent.width * 0.9
            height: parent.height * 0.15
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 15

            color: "#313537";

            Rectangle {
                id: revCounter
                width: parent.width * (vrData.rpm / vrData.maxRpm)
                height: parent.height
                anchors.top: parent.top
                anchors.left: parent.left


                color: (vrData.rpm / vrData.maxRpm) > 0.9 ? "red" : "lime"
            }
        }

        Text {
            id: gearLabel
            text: gearIndexToChar(vrData.gear)
            color: "white"
            horizontalAlignment: Text.Center
            font {
                bold: true
                pixelSize: ((parent.width - 25) * 0.2) * ((parent.height - 25) * 0.2) * 0.03
            }

            anchors.centerIn: parent

            function gearIndexToChar(index) {
                if (index === 0)
                    return 'N';
                else if (index === -1)
                    return 'R';
                return '' + index;
            }
        }

        Text {
            id: velocityLabel
            text: vrData.velocity.toFixed(0)
            color: "white"
            horizontalAlignment: Text.AlignRight
            font {
                pixelSize: gearLabel.font.pixelSize * 0.33
            }

            width: parent.width * 0.3

            anchors.bottom: gearLabel.verticalCenter
            anchors.left: parent.left
        }

        Text {
            text: "km/h"
            color: "white"
            font {
                pixelSize: velocityLabel.font.pixelSize * 0.5
            }

            anchors.top: velocityLabel.bottom
            anchors.right: velocityLabel.right
        }


        Text {
            id: rpmLabel
            text: vrData.rpm
            color: "white"
            horizontalAlignment: Text.AlignRight
            font {
                pixelSize: velocityLabel.font.pixelSize
            }

            width: parent.width * 0.3

            anchors.bottom: gearLabel.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 20
        }

        Text {
            text: "RPM"
            color: "white"
            font {
                pixelSize: rpmLabel.font.pixelSize * 0.5
            }

            anchors.top: rpmLabel.bottom
            anchors.right: rpmLabel.right
        }

        Row {
            id: statusRow
            anchors.bottom: generalInfoTile.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * 0.25

            Rectangle {
                id: status1
                height: parent.height
                width: parent.width * 0.25

                color: "transparent"
                border.color: "#a7def9"

                Text {
                    width: parent.width
                    anchors.centerIn: parent
                    horizontalAlignment: Text.Center

                    wrapMode: Text.WordWrap
                    font.pixelSize: parent.height * 0.3
                    color: (false ? "lime" : "#798489")

                    text: "-"
                }
            }

            Rectangle {
                id: status2
                height: parent.height
                width: parent.width * 0.25

                color: "transparent"
                border.color: "#a7def9"

                Text {
                    width: parent.width
                    anchors.centerIn: parent
                    horizontalAlignment: Text.Center

                    wrapMode: Text.WordWrap
                    font.pixelSize: parent.height * 0.3
                    color: (false ? "lime" : "#798489")

                    text: "-"
                }
            }

            Rectangle {
                id: status3
                height: parent.height
                width: parent.width * 0.25

                color: "transparent"
                border.color: "#a7def9"

                Text {
                    width: parent.width
                    anchors.centerIn: parent
                    horizontalAlignment: Text.Center

                    wrapMode: Text.WordWrap
                    font.pixelSize: parent.height * 0.3
                    color: (vrData.pitLimiter ? "lime" : "#798489")

                    text: "Pit Limiter"
                }
            }

            Rectangle {
                id: status4
                height: parent.height
                width: parent.width * 0.25

                color: "transparent"
                border.color: "#a7def9"

                Text {
                    width: parent.width
                    anchors.centerIn: parent
                    horizontalAlignment: Text.Center

                    wrapMode: Text.WordWrap
                    font.pixelSize: parent.height * 0.3
                    color: (vrData.isInPitlane ? "lime" : "#798489")

                    text: "In Pitlane"
                }
            }
        }
    }
    //////////////////////////////////////////////////////////////////////

    VRPlotVelocity {
        id: velocityPlot
        objectName: "velocityPlot"
        width: parent.width / 3
        height: parent.height * 0.5
        anchors.right: parent.right
        anchors.top: parent.top

        Component.onCompleted: initCustomPlot()

        Timer {
            interval: 20
            running: true
            repeat: true
            onTriggered: velocityPlot.pushData(vrData.getTimeInSeconds(), vrData.velocity)
        }
    }

    VRPlotPedalHistory {
        id: pedalHistoryPlot
        width: parent.width * 0.25
        height: parent.height * 0.5
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        Component.onCompleted: initCustomPlot()
    }

    VRPlotPedals {
        id: pedalsPlot
        width: parent.width * 0.25
        height: parent.height * 0.5
        anchors.left: pedalHistoryPlot.right
        anchors.bottom: parent.bottom

        Component.onCompleted: initCustomPlot()

        Connections {
            target: vrData
            onThrottleChanged: update(vrData.throttle, vrData.brake, vrData.clutch)
            onBrakeChanged: update(vrData.throttle, vrData.brake, vrData.clutch)
            onClutchChanged: update(vrData.throttle, vrData.brake, vrData.clutch)

            function update(throttle, brake, clutch) {
                pedalsPlot.pushData(clutch, brake, throttle);
            }
        }

        Timer {
            interval: 20
            running: true
            repeat: true
            onTriggered: pedalHistoryPlot.pushData(vrData.getTimeInSeconds(), vrData.clutch, vrData.brake, vrData.throttle)
        }
    }

    Rectangle {
        id: laptimeOverview
        width: parent.width * 0.25
        height: parent.height * 0.47
        anchors.left: pedalsPlot.right
        anchors.bottom: parent.bottom
        anchors.margins: 15

        color: "transparent"
        border.color: "#a7def9"

        Text {
            id: lapsTitle
            text: "Laptimes"
            color: "white"

            font.pixelSize: (laptimeOverview.width * 0.2) * (laptimeOverview.height * 0.2) * 0.0075;

            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 5
        }

        GridLayout {
            columns: 2
            anchors.centerIn: parent

            Text {
                id: currentLapLabel
                text: "Current:"
                color: "white"
                Layout.rightMargin: 20
                Layout.bottomMargin: 10

                font.pixelSize: ((laptimeOverview.width - 25) * 0.15) * ((laptimeOverview.height - 25) * 0.15) * 0.01;
            }

            Text {
                id: currentLapValue
                text: "1:23.2"
                color: "white"
                Layout.bottomMargin: 10

                font.bold: true
                font.pixelSize: currentLapLabel.font.pixelSize
            }

            Text {
                id: lastLapLabel
                text: "Last:"
                color: "white"
                Layout.rightMargin: 20
                Layout.bottomMargin: 10

                font.pixelSize: currentLapLabel.font.pixelSize
            }

            Text {
                id: lastLapValue
                text: "1:23.2"
                color: "white"
                Layout.bottomMargin: 10

                font.bold: true
                font.pixelSize: currentLapLabel.font.pixelSize
            }

            Text {
                id: bestLapLabel
                text: "Best:"
                color: "white"
                Layout.rightMargin: 20
                Layout.bottomMargin: 10

                font.pixelSize: currentLapLabel.font.pixelSize
            }

            Text {
                id: bestLapValue
                text: "1:23.2"
                color: "white"
                Layout.bottomMargin: 10

                font.bold: true
                font.pixelSize: currentLapLabel.font.pixelSize
            }
        }
    }
}
