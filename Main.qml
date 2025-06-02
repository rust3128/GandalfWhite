import QtQuick
import QtQuick.Controls // Для кнопок та текстових полів
import QtQuick.Layouts // Для зручного розташування елементів

Window {
    width: 640
    height: 600 // Збільшуємо висоту для розміщення нових елементів
    visible: true
    title: "GandalfWhite"

    // Тут ми підключаємося до нашого C++ об'єкта "backendClient"
    // Він був зареєстрований у main.cpp
    Connections {
        target: backendClient

        function onStatusReceived(data) { // <<< ЗМІНЕНО: Додано "function" та список аргументів (data)
            statusOutput.text = JSON.stringify(data, null, 2) // Форматуємо JSON для кращого відображення
            console.log("QML: Status Data Received: ", JSON.stringify(data))
        }

        function onVersionReceived(data) { // <<< ЗМІНЕНО: Додано "function" та список аргументів (data)
            versionOutput.text = JSON.stringify(data, null, 2) // Форматуємо JSON
            console.log("QML: Version Data Received: ", JSON.stringify(data))
        }

        function onNetworkError(errorMessage) { // <<< ЗМІНЕНО: Додано "function" та список аргументів (errorMessage)
            errorOutput.text = "Error: " + errorMessage
            console.error("QML: Network Error: ", errorMessage)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Label {
            text: "ArnorBeacon Server Status/Version"
            font.pixelSize: 24
            Layout.alignment: Qt.AlignHCenter
        }

        // Секція для Status
        RowLayout {
            Layout.fillWidth: true
            Button {
                text: "Запит /status"
                onClicked: {
                    statusOutput.text = "Завантаження..."
                    errorOutput.text = "" // Очищаємо помилки
                    backendClient.requestStatus()
                }
            }
            Label {
                text: "Відповідь /status:"
            }
            TextArea {
                id: statusOutput
                Layout.fillWidth: true
                Layout.minimumHeight: 100
                readOnly: true
                text: "Натисніть кнопку для отримання статусу"
            }
        }

        // Секція для Version
        RowLayout {
            Layout.fillWidth: true
            Button {
                text: "Запит /version"
                onClicked: {
                    versionOutput.text = "Завантаження..."
                    errorOutput.text = "" // Очищаємо помилки
                    backendClient.requestVersion()
                }
            }
            Label {
                text: "Відповідь /version:"
            }
            TextArea {
                id: versionOutput
                Layout.fillWidth: true
                Layout.minimumHeight: 150
                readOnly: true
                text: "Натисніть кнопку для отримання версії"
            }
        }

        // Секція для відображення помилок
        TextArea {
            id: errorOutput
            Layout.fillWidth: true
            Layout.minimumHeight: 50
            readOnly: true
            text: "Тут будуть відображатися помилки мережі"
            color: "red"
        }
    }
}
