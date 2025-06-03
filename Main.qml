// Main.qml - це основний файл інтерфейсу вашого клієнтського застосунку GandalfWhite.

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    width: 640
    height: 480 // Зменшимо висоту, оскільки менше елементів
    visible: true
    title: "GandalfWhite - ArnorBeacon Client (Status Only)"

    // ---------- БЛОК ІНТЕГРАЦІЇ З C++ (backendClient) ----------
    Connections {
        target: backendClient

        function onStatusReceived(data) {
            // Оновлюємо детальне поле статусу
            statusOutput.text = JSON.stringify(data, null, 2)
            console.log("QML: Status Data Received: ", JSON.stringify(data))

            // Оновлюємо загальний статус у "статус-барі"
            // data.status є "ok", якщо все добре, або інше значення з JSON
            generalStatusLabel.text = "Сервер: " + data.status + " | Оновлено: " + data.timestamp;

            // Запускаємо таймер тільки після першого успішного отримання статусу
            if (!requestTimer.running) {
                requestTimer.start();
            }
        }

        // Версія поки що не обробляється і не відображається детально
        function onVersionReceived(data) {
            // console.log("QML: Version Data Received (not displayed): ", JSON.stringify(data))
            // Якщо таймер не запущений, запускаємо його після отримання будь-якої відповіді
            if (!requestTimer.running) {
                requestTimer.start();
            }
        }

        function onNetworkError(errorMessage) {
            // Оновлюємо поле помилок
            errorOutput.text = "Error: " + errorMessage
            console.error("QML: Network Error: ", errorMessage)
            // Оновлюємо загальний статус у "статус-барі" при помилці
            generalStatusLabel.text = "ПОМИЛКА! " + errorMessage;
            // Зупиняємо таймер при помилці, щоб не надсилати запити безперервно
            requestTimer.stop();
        }
    }
    // ---------- КІНЕЦЬ БЛОГІВ ІНТЕГРАЦІЇ З C++ ----------

    // Таймер для періодичного запиту статусу
    Timer {
        id: requestTimer
        interval: 5000 // Інтервал у мілісекундах (5 секунд)
        running: false // Спочатку не запущено
        repeat: true // Повторювати запити
        onTriggered: {
            // Виконуємо запит статусу
            generalStatusLabel.text = "Запит статусу...";
            statusOutput.text = "Завантаження статусу...";
            errorOutput.text = ""; // Очищаємо помилки перед новим запитом
            backendClient.requestStatus();
        }
    }

    // Цей блок виконується, коли компонент Window повністю завантажений та ініціалізований.
    Component.onCompleted: {
        console.log("QML: Window component completed. Initiating initial status request.");
        // Ініціюємо перший запит статусу одразу після запуску.
        // Таймер запуститься з onStatusReceived або onNetworkError.
        generalStatusLabel.text = "Ініціалізація запиту...";
        statusOutput.text = "Завантаження статусу...";
        errorOutput.text = "";
        backendClient.requestStatus();
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Label {
            text: "ArnorBeacon Server Status"
            font.pixelSize: 24
            Layout.alignment: Qt.AlignHCenter
        }

        // Розгорнуте поле для детального статусу (якщо потрібно бачити весь JSON)
        TextArea {
            id: statusOutput
            Layout.fillWidth: true
            Layout.fillHeight: true // Дозволяємо займати всю доступну висоту
            readOnly: true
            text: "Очікування статусу..."
        }

        // Статус-бар внизу вікна
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 30 // Фіксована висота для статус-бару
            color: "lightgray"
            border.color: "gray"
            border.width: 1

            Label {
                id: generalStatusLabel
                anchors.fill: parent
                anchors.margins: 5
                verticalAlignment: Text.AlignVCenter
                text: "Застосунок запущено." // Початковий текст статус-бару
                font.pixelSize: 14
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
