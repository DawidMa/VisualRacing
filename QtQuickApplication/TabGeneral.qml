import QtQuick 2.0
import VRPlot 1.0

Rectangle{
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
                id: revCounter
                width: parent.width * 0.9
                height: parent.height * 0.15
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 15

                color: "blue"
            }

            Text {
                id: gearLabel
                color: "white"
                horizontalAlignment: Text.Center
                font {
                    bold: true
                    pixelSize: ((parent.width - 25) * 0.2) * ((parent.height - 25) * 0.2) * 0.03
                }

                anchors.centerIn: parent
            }

            Text {
                id: velocityLabel
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
        }
        //////////////////////////////////////////////////////////////////////

        VRPlotVelocity {

            property double index: 0

            id: velocityPlot
            objectName: "velocityPlot"
            width: parent.width / 3
            height: parent.height * 0.5
            anchors.right: parent.right
            anchors.top: parent.top

            Component.onCompleted: initCustomPlot()

            Timer {
                interval: 50
                running: true
                repeat: true
                onTriggered: velocityPlot.push()
            }

            // push some Demo data
            function push(){
                var tmp_rpm = (Math.cos(velocityPlot.index) * 2500 + 2500);
                var tmp_gear = (velocityPlot.index % 8);
                rpmPlot.pushData(velocityPlot.index, tmp_rpm, tmp_gear);
                var tmp_velo = (Math.sin(velocityPlot.index) * 120 + 120);
                velocityPlot.pushData(velocityPlot.index, tmp_velo);

                velocityLabel.text = tmp_velo.toFixed(0);
                gearLabel.text = (tmp_gear.toFixed(0) == 0 ? "N" : tmp_gear.toFixed(0));
                rpmLabel.text = tmp_rpm.toFixed(0);

                velocityPlot.index += 0.1;
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

            property double index: 0

            id: pedalsPlot
            width: parent.width * 0.25
            height: parent.height * 0.5
            anchors.left: pedalHistoryPlot.right
            anchors.bottom: parent.bottom

            Component.onCompleted: initCustomPlot()

            Timer {
                interval: 70
                running: true
                repeat: true
                onTriggered: pedalsPlot.push()
            }

            // push some Demo data
            function push(){
                pedalsPlot.pushData((-Math.sin(pedalsPlot.index) * 50 + 50),
                                    (Math.sin(pedalsPlot.index*0.5) * 30 + 30),
                                    (Math.sin(pedalsPlot.index) * 50 + 50));
                pedalHistoryPlot.pushData(pedalsPlot.index,
                                          (-Math.sin(pedalsPlot.index) * 50 + 50),
                                          (Math.sin(pedalsPlot.index*0.5) * 30 + 30),
                                          (Math.sin(pedalsPlot.index) * 50 + 50));
                pedalsPlot.index += 0.1;
            }
        }
}