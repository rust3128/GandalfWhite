// Main.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: appWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("GandalfWhite - ArnorBeacon Client") // Заголовок вікна

    // --- Header (Верхня панель) - ВІДНОВЛЕНО З ВАШОГО КОДУ ---
    header: ToolBar {
        width: parent.width

        RowLayout {
            width: parent.width
            spacing: 0

            ToolButton {
                text: qsTr("\u2630")
                font.pixelSize: 24
                onClicked: drawer.open()
            }

            Label {
                text: appWindow.title
                font.pixelSize: 20
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    // --- Кінець Header ---

    // --- Бічне меню (Drawer) ---
    Drawer {
        id: drawer
        width: 250
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

            Label {
                text: "Меню"
                font.pixelSize: 20
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "lightgray"
            }

            Button {
                text: "Про програму"
                Layout.fillWidth: true
                onClicked: {
                    console.log("QML: 'Про програму' clicked.");
                    drawer.close();
                    aboutDialog.open();
                }
            }
        }
    }

    // Додаємо екземпляр діалогу "Про програму"
    AboutDialog {
        id: aboutDialog
        anchors.centerIn: parent
    }
}
