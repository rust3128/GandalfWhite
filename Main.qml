// Main.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15 // Додайте, якщо немає


ApplicationWindow {
    id: appWindow
    visible: true
    width: 1280
    height: 960
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
        width: 200 // Ваша поточна ширина
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        ColumnLayout { // <--- ЗМІНЮЄМО ТУТ
            anchors.fill: parent // <--- ВІДНОВІТЬ ЦЕЙ РЯДОК
            anchors.margins: 10
            spacing: 0 // Залишимо 0, щоб кнопки були максимально близько

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
                text: "Налаштування" // Текст повернеться
                Layout.fillWidth: true
                Layout.preferredHeight: 30 // Можна залишити або прибрати, якщо хочете автовисоту
                topPadding: 0
                bottomPadding: 0
                background: Rectangle {
                    color: parent.pressed ? "#E0E0E0" : "#F0F0F0"
                    radius: 5
                }
                onClicked: {
                    console.log("QML: 'Налаштування' clicked.");
                    drawer.close();
                    settingsDialog.open();
                }
            }

            Button {
                text: "Про програму" // Текст повернеться
                Layout.fillWidth: true
                Layout.preferredHeight: 30 // Можна залишити або прибрати
                topPadding: 0
                bottomPadding: 0
                background: Rectangle {
                    color: parent.pressed ? "#E0E0E0" : "#F0F0F0"
                    radius: 5
                }
                onClicked: {
                    console.log("QML: 'Про програму' clicked.");
                    drawer.close();
                    aboutDialog.open();
                }
            }

            Item { Layout.fillHeight: true } // Цей елемент залишається, щоб відштовхувати кнопки до верху
        }
    }


    // Додаємо екземпляр діалогу "Про програму"
    AboutDialog {
        id: aboutDialog
        anchors.centerIn: parent
    }
    // --- ДОДАЄМО ЕКЗЕМПЛЯР ДІАЛОГУ "Налаштування" ---
    SettingsDialog {
        id: settingsDialog
        anchors.centerIn: parent
    }
    // --- КІНЕЦЬ ДОДАВАННЯ ДІАЛОГУ "Налаштування" ---
}
