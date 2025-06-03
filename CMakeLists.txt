cmake_minimum_required(VERSION 3.16)

project(GandalfWhite VERSION 1.0.0 LANGUAGES CXX) # Додаємо VERSION, якщо немає

set(CMAKE_CXX_STANDARD_REQUIRED ON)

# --- Логіка версіонування GandalfWhite Client ---

# Шляхи до файлів версіонування
set(BUILD_NUMBER_FILE "${CMAKE_CURRENT_SOURCE_DIR}/build_number.txt")
set(VERSION_H_IN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/version.h.in")
set(VERSION_H_OUT_FILE "${CMAKE_CURRENT_BINARY_DIR}/version.h") # Згенерований файл буде в директорії збірки

# Перевіряємо, чи існує build_number.txt. Якщо ні, створюємо його зі значенням 100.
if(NOT EXISTS ${BUILD_NUMBER_FILE})
    message(STATUS "Creating ${BUILD_NUMBER_FILE} with initial build number 100.")
    file(WRITE ${BUILD_NUMBER_FILE} "100")
endif()

# Зчитуємо поточний номер збірки
file(READ ${BUILD_NUMBER_FILE} CURRENT_BUILD_NUMBER)
string(STRIP "${CURRENT_BUILD_NUMBER}" CURRENT_BUILD_NUMBER) # Видаляємо зайві пробіли/переноси рядків

# Інкрементуємо номер збірки
math(EXPR NEW_BUILD_NUMBER "${CURRENT_BUILD_NUMBER} + 1")
message(STATUS "Incrementing build number from ${CURRENT_BUILD_NUMBER} to ${NEW_BUILD_NUMBER}")

# Записуємо новий номер збірки назад у файл
file(WRITE ${BUILD_NUMBER_FILE} "${NEW_BUILD_NUMBER}")

# Встановлюємо змінну CMake для номера збірки, яка буде використана в configure_file
set(GW_VERSION_BUILD "${NEW_BUILD_NUMBER}")

# Отримуємо поточну дату та час збірки
# Використовуємо UTC для стабільності, але можна змінити на LOCAL
string(TIMESTAMP GW_BUILD_DATE_CMAKE "%b %d %Y" UTC) # Наприклад: "Jun 03 2025"
string(TIMESTAMP GW_BUILD_TIME_CMAKE "%H:%M:%S" UTC) # Наприклад: "09:55:30"
set(GW_BUILD_DATETIME_CMAKE "${GW_BUILD_DATE_CMAKE} ${GW_BUILD_TIME_CMAKE}")

# Конфігуруємо version.h з шаблону version.h.in
# Це замінить @VAR@ на значення змінних CMake
configure_file(
    "${VERSION_H_IN_FILE}"
    "${VERSION_H_OUT_FILE}"
    @ONLY # Важливо: замінює лише @VAR@, а не ${VAR}
)

# Додаємо директорію згенерованого version.h до шляхів включення заголовків
# Це дозволить C++ файлам використовувати #include "version.h"
include_directories("${CMAKE_CURRENT_BINARY_DIR}")

# Важливо: Додаємо згенерований version.h до вихідних файлів проєкту,
# щоб IDE (Qt Creator) бачила його і включала в автодоповнення тощо.
# Це також може допомогти з правильними залежностями збірки.
# Якщо у вас є list (наприклад, SOURCE_FILES) до add_executable, додайте його туди.
# Якщо ні, CMake автоматично його знайде після include_directories.
# Однак, якщо ви явно вказуєте заголовки для проекту, то додайте:
# set(PROJECT_HEADERS ${PROJECT_HEADERS} ${VERSION_H_OUT_FILE})
# або додайте в add_executable, якщо воно приймає заголовки.
# Для більшості CMake-проектів достатньо include_directories().

# --- Кінець логіки версіонування ---

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)




qt_add_executable(GandalfWhite
    main.cpp
    gandalf_white.rc
)

qt_add_qml_module(GandalfWhite
    URI GandalfWhite
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES backendclient.h backendclient.cpp
        RESOURCES GandalfWhite.qrc
        QML_FILES AboutDialog.qml
        RESOURCES build_number.txt
        RESOURCES
        RESOURCES version.h.in
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(GandalfWhite PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.GandalfWhite
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(GandalfWhite
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS GandalfWhite
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
