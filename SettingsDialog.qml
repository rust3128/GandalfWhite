// SettingsDialog.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Dialog {
    id: settingsDialog
    title: qsTr("Налаштування")
    width: 600
    height: 400
    modal: true

    background: Rectangle {
        color: settingsDialog.Material.background
        radius: 15
        border.color: "lightgray"
        border.width: 1
    }

    contentItem: Item {
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Label {
                    text: qsTr("Адреса:")
                    font.pixelSize: 16
                    Layout.preferredWidth: implicitWidth + 5
                }

                TextField {
                    id: serverAddressField
                    Layout.fillWidth: true
                    text: "http://localhost:8080"
                    Layout.preferredHeight: 40
                }

                Label {
                    text: qsTr("Порт:")
                    font.pixelSize: 16
                    Layout.preferredWidth: implicitWidth + 5
                }

                // --- КЛЮЧОВА ЗМІНА: ПОВЕРТАЄМО TextField ДЛЯ ПОРТУ ---
                TextField { // Змінюємо SpinBox на TextField
                    id: serverPortField // Змінюємо id на serverPortField
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 40 // Залишаємо висоту

                    text: "8080" // Початкове значення
                    validator: IntValidator { // Повертаємо валідатор для коректності
                        bottom: 1
                        top: 65535
                    }
                    // Ми прибрали background та padding раніше, що дало нормальний вигляд.
                    // Якщо знову будуть проблеми з накладанням, це буде останньою індикацією,
                    // що ми маємо проблему з Material Design.
                }
                // --- КІНЕЦЬ ЗМІН ---
            }
        }
    }

    footer: Frame {
        Layout.fillWidth: true
        padding: 10

        Button {
            text: qsTr("OK")
            onClicked: settingsDialog.close()
            width: 100
            height: 40
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    onOpened: {
        console.log("QML: Діалог 'Налаштування' відкрито.");
    }

    onClosed: {
        console.log("QML: Діалог 'Налаштування' закрито.");
    }
}
