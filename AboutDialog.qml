// AboutDialog.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Dialog {
    id: aboutDialog
    title: "Про програму GandalfWhite"
    width: 400
    height: 300
    // Встановлюємо діалог як модальний, щоб блокувати основне вікно
    modal: true
    // Центруємо діалог відносно батьківського вікна (ApplicationWindow)
    // Це потрібно, якщо ви викликаєте його без open(parent)
    anchors.centerIn: parent // Зазвичай, Dialog'и краще відкривати через open() з посиланням на батьківське вікно

    // Кнопка для закриття діалогу
    standardButtons: Dialog.Ok

    // Вміст діалогу
    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        Label {
            text: "<b>Назва:</b> GandalfWhite Client"
            font.pixelSize: 16
        }

        Label {
            text: "<b>Версія:</b> 1.0.0 (Збірка: 1234)" // Це поки що хардкод, далі візьмемо з C++
            font.pixelSize: 16
        }

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

        Item { Layout.fillHeight: true } // Розширювач, щоб притиснути кнопку до низу

        Label {
            text: "© 2025 Всі права захищені."
            font.pixelSize: 12
            color: "darkgray"
            Layout.alignment: Qt.AlignHCenter
        }
    }

    // Коли діалог закривається, можна виконати якусь дію (опціонально)
    onClosed: {
        console.log("QML: Діалог 'Про програму' закрито.");
    }
}
