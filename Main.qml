// Main.qml - це основний файл інтерфейсу вашого клієнтського застосунку GandalfWhite.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// Використовуємо ApplicationWindow замість Window для більш складного інтерфейсу
ApplicationWindow {
    id: appWindow // Додамо ID для посилання на вікно
    width: 800 // Збільшимо ширину для бічного меню
    height: 600
    visible: true
    title: "GandalfWhite - ArnorBeacon Client"

    // ---------- БЛОК ІНТЕГРАЦІЇ З C++ (backendClient) ----------
    Connections {
        target: backendClient

        function onStatusReceived(data) {
            // Тепер ми не відображаємо детальний статус в інтерфейсі,
            // і не надсилаємо автоматичні запити.
            console.log("QML: Status Data Received (not displayed): ", JSON.stringify(data));
        }

        // Версія поки що не обробляється
        function onVersionReceived(data) {
            console.log("QML: Version Data Received (not displayed): ", JSON.stringify(data));
        }

        function onNetworkError(errorMessage) {
            console.error("QML: Network Error (not displayed): ", errorMessage);
        }
    }
    // ---------- КІНЕЦЬ БЛОГІВ ІНТЕГРАЦІЇ З C++ ----------

    // --- Header (Верхня панель) ---
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

    // --- Бічне меню (Drawer) ---
    Drawer {
        id: drawer
        // Залишаємо без anchors, ApplicationWindow сам їх правильно розміщує
        width: 250 // Ширина бічного меню
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
                    aboutDialog.open(appWindow); // <<< ВІДКРИВАЄМО ДІАЛОГ, ЦЕНТРУЮЧИ ВІДНОСНО appWindow
                }
            }
        }
    }

    // --- Головний вміст вікна ---
    ColumnLayout {
        anchors.fill: parent // ApplicationWindow автоматично керує розміром і положенням основного вмісту
        anchors.margins: 10 // Залишаємо відступи
        spacing: 10

        Label {
            text: "Ласкаво просимо до GandalfWhite Client!"
            font.pixelSize: 18
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 50 // Невеликий відступ від верху
        }
    }
    // >>>>>>>>>>> ДОДАЙТЕ ЦЕЙ НОВИЙ БЛОК СЮДИ <<<<<<<<<<<
    // Додаємо екземпляр нашого діалогу "Про програму"
    AboutDialog {
        id: aboutDialog // Ми даємо йому ID, щоб мати змогу посилатися на нього з інших частин коду QML
    }
}
