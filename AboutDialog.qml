// AboutDialog.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15 // ОБОВ'ЯЗКОВО для Material.background

Dialog {
    id: aboutDialog
    title: "Про програму GandalfWhite"
    width: 400
    height: 480
    modal: true

    // --- Закруглені кути для фону діалогу ---
    background: Rectangle {
        color: aboutDialog.Material.background // Використовуємо колір з Material Design
        radius: 15 // Радіус закруглення
        border.color: "lightgray"
        border.width: 1
    }
    // --- Кінець закруглених кутів ---

    // standardButtons: undefined  <-- ЦЕЙ РЯДОК БУВ ВИДАЛЕНИЙ!

    footer: Frame { // Використовуємо футер для кастомної кнопки
        Layout.fillWidth: true
        padding: 10 // Відступи навколо кнопки

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter // Центруємо вміст RowLayout (нашу кнопку)

            Button {
                text: "OK" // Встановлюємо текст кнопки явно
                onClicked: aboutDialog.close() // Закриваємо діалог
                Layout.preferredWidth: 100 // Задаємо фіксовану ширину
            }
        }
    }
    // --- Кінець центрування кнопки "OK" ---

    Connections {
        target: backendClient

        function onVersionReceived(data) {
            serverFullVersionLabel.text = "<b>Повна версія:</b> " + data.version.full_version;
            serverBuildDateTimeLabel.text = "<b>Час збірки:</b> " + data.version.build_datetime;
            console.log("QML: Server Version Data Applied to AboutDialog.");
        }

        function onNetworkError(errorMessage) {
            serverFullVersionLabel.text = "<b>Версія сервера:</b> Помилка: " + errorMessage;
            serverBuildDateTimeLabel.text = "";
            console.error("QML: Error getting server version in AboutDialog:", errorMessage);
        }
    }

    contentItem: ScrollView {
        implicitWidth: aboutDialog.width
        implicitHeight: aboutDialog.height

        ColumnLayout {
            width: parent.width
            anchors.margins: 15
            spacing: 5

            Label {
                text: "<b>Про програму GandalfWhite Client</b>"
                font.pixelSize: 18
                Layout.alignment: Qt.AlignHCenter
            }

            Label {
                id: clientVersionLabel
                text: "<b>Версія клієнта:</b> " + backendClient.clientVersionString
                font.pixelSize: 16
            }
            Label {
                id: clientBuildDateLabel
                text: "<b>Дата збірки:</b> " + backendClient.clientBuildDate
                font.pixelSize: 14
                color: "gray"
            }
            Label {
                id: clientBuildTimeLabel
                text: "<b>Час збірки:</b> " + backendClient.clientBuildTime
                font.pixelSize: 14
                color: "gray"
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "lightgray"
            }

            Label {
                text: "<b>Про сервер ArnorBeacon</b>"
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
            }

            Label {
                id: serverFullVersionLabel
                text: "<b>Версія сервера:</b> Завантаження..."
                font.pixelSize: 16
            }
            Label {
                id: serverBuildDateTimeLabel
                text: ""
                font.pixelSize: 14
                color: "gray"
            }

            Item { Layout.fillHeight: true }

            Label {
                text: "<b>Опис:</b> Клієнт для моніторингу стану сервера ArnorBeacon."
                wrapMode: Label.WordWrap
                font.pixelSize: 14
            }
            Label {
                text: "<b>Автор:</b> Ваше Ім'я/Компанія"
                font.pixelSize: 14
                color: "gray"
            }
            Label {
                text: "© 2025 Всі права захищені."
                font.pixelSize: 12
                color: "darkgray"
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    onOpened: {
        backendClient.requestVersion();
        console.log("QML: Діалог 'Про програму' відкрито.");
    }

    onClosed: {
        console.log("QML: Діалог 'Про програму' закрито.");
        serverFullVersionLabel.text = "<b>Версія сервера:</b> Завантаження...";
        serverBuildDateTimeLabel.text = "";
    }
}
