// AboutDialog.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Dialog {
    id: aboutDialog
    title: "Про програму GandalfWhite"
    width: 400
    height: 480 // Або ваша оптимальна висота
    modal: true

    // Додаємо локальні властивості для зберігання версії клієнта
    property string _clientVersionString: ""
    property string _clientBuildDate: ""
    property string _clientBuildTime: ""

    background: Rectangle {
        color: aboutDialog.Material.background
        radius: 15
        border.color: "lightgray"
        border.width: 1
    }

    footer: Frame { // Використовуємо Frame у футері
        Layout.fillWidth: true // Футер заповнює всю доступну ширину
        padding: 10 // Відступи навколо кнопки

        // Ми видаляємо RowLayout і розміщуємо кнопку прямо у Frame,
        // використовуючи anchors для центрування.
        Button {
            text: "OK"
            onClicked: aboutDialog.close()
            width: 100 // Задаємо фіксовану ширину для кнопки
            height: 40 // Можливо, задати фіксовану висоту для кращого вигляду

            // !!! ГОЛОВНА ЗМІНА: Прив'язуємо горизонтальний центр кнопки до центру батьківського Frame !!!
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter // Центруємо також по вертикалі у футері
        }
    }

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
                text: "<b>Версія клієнта:</b> " + aboutDialog._clientVersionString
                font.pixelSize: 16
            }
            Label {
                id: clientBuildDateLabel
                text: "<b>Дата збірки:</b> " + aboutDialog._clientBuildDate
                font.pixelSize: 14
                color: "gray"
            }
            Label {
                id: clientBuildTimeLabel
                text: "<b>Час збірки:</b> " + aboutDialog._clientBuildTime
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

    Component.onCompleted: {
        if (backendClient) { // Перевірка, щоб уникнути помилок
            _clientVersionString = backendClient.clientVersionString;
            _clientBuildDate = backendClient.clientBuildDate;
            _clientBuildTime = backendClient.clientBuildTime;
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
