// AboutDialog.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: aboutDialog
    title: "Про програму GandalfWhite"
    width: 400
    height: 360 // Або ваша оптимальна висота
    modal: true

    standardButtons: Dialog.Ok

    Connections {
        target: backendClient

        function onVersionReceived(data) {
            // Ці дані надходять з сервера ArnorBeacon
            serverFullVersionLabel.text = "<b>Повна версія:</b> " + data.version.full_version;
            // !!! ВИДАЛІТЬ ЦІ РЯДКИ:
            // serverMajorLabel.text = "<b>Major:</b> " + data.version.major;
            // serverMinorLabel.text = "<b>Minor:</b> " + data.version.minor;
            // serverBuildLabel.text = "<b>Build:</b> " + data.version.build;
            serverBuildDateTimeLabel.text = "<b>Час збірки:</b> " + data.version.build_datetime; // Використовуйте build_datetime
            console.log("QML: Server Version Data Applied to AboutDialog.");
        }

        function onNetworkError(errorMessage) {
            // Обробка помилок для версії сервера
            serverFullVersionLabel.text = "<b>Версія сервера:</b> Помилка: " + errorMessage;
            // !!! ВИДАЛІТЬ ЦІ РЯДКИ АБО ЗРОБІТЬ ЇХ ПУСТИМИ:
            // serverMajorLabel.text = "";
            // serverMinorLabel.text = "";
            // serverBuildLabel.text = "";
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
            spacing: 5 // Або те значення, яке ви встановили для зменшення відстані

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
            // !!! ВИДАЛІТЬ ЦІ БЛОКИ Label:
            // Label {
            //     id: serverMajorLabel
            //     text: ""
            //     font.pixelSize: 14
            //     color: "gray"
            // }
            // Label {
            //     id: serverMinorLabel
            //     text: ""
            //     font.pixelSize: 14
            //     color: "gray"
            // }
            // Label {
            //     id: serverBuildLabel
            //     text: ""
            //     font.pixelSize: 14
            //     color: "gray"
            // }
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
                text: "<b>Автор:</b> Ruslan Polupan/ПромТерміналСервіс"
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
        // Скидаємо інформацію про сервер, щоб при наступному відкритті була анімація завантаження
        serverFullVersionLabel.text = "<b>Версія сервера:</b> Завантаження...";
        // !!! ВИДАЛІТЬ ЦІ РЯДКИ АБО ЗРОБІТЬ ЇХ ПУСТИМИ:
        // serverMajorLabel.text = "";
        // serverMinorLabel.text = "";
        // serverBuildLabel.text = "";
        serverBuildDateTimeLabel.text = "";
    }
}
