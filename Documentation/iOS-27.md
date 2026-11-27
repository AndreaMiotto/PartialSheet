# Подготовка PartialSheet к iOS 27

Основа: AndreaMiotto/PartialSheet, commit `76b8ba559cde8124a2d8d3363b9da3fafabcef9f`.
Ветка: `codex/ios-27-compatibility`.

Это локальная адаптация. Проверка непосредственно с SDK/runtime iOS 27 ещё не выполнена: на машине установлен Xcode 26.4.1 (17E202), SDK iOS 26.4. Не считать эту ветку сертифицированной для iOS 27 до проверки в Xcode 27.

## Подключение

Удалите прежнюю зависимость PartialSheet из проекта и добавьте эту папку через Xcode → File → Add Package Dependencies → Add Local. Добавьте продукт `PartialSheet` в target приложения. Не подключайте одновременно оригинал и локальную копию.

Публичные сигнатуры сохранены. Минимальная версия остаётся iOS 15; повышать deployment target до 27 для использования на iOS 27 не требуется. Поддерживается iOS/iPadOS и UIKit через Mac Catalyst; отдельный native macOS target не добавлялся.

```swift
import SwiftUI
import PartialSheet

struct ContentView: View {
    @State private var isPresented = false

    var body: some View {
        Button("Открыть") { isPresented = true }
            .partialSheet(isPresented: $isPresented) {
                VStack(spacing: 16) {
                    Text("PartialSheet")
                    Button("Закрыть") { isPresented = false }
                }
                .padding()
            }
    }
}

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .attachPartialSheetToRoot()
        }
    }
}
```

Прикрепляйте менеджер один раз на корень каждого окна, снаружи навигационного контейнера. Для длинного содержимого используйте существующий `type: .scrollView(height: 400, showsIndicators: true)`. Высота этого режима ограничивается доступной высотой контейнера; `.dynamic` предназначен для содержимого, помещающегося на экране.

## Изменения

- `@StateObject` сохраняет менеджер между пересчётами корневого view; UI-состояние изолировано на `MainActor`.
- Размер листа определяется геометрией конкретного контейнера, без `UIScreen.main` и поиска key window среди всех сцен.
- SwiftUI управляет доступной областью при появлении клавиатуры. Удалены наблюдатели NotificationCenter, которые не снимались корректно, и неиспользуемый keyboard offset.
- Удалена отложенная очистка через 0,35 секунды, способная стереть повторно открытый лист. Последнее содержимое хранится до следующего показа или уничтожения корневого менеджера, чтобы поддерживать пользовательские анимации закрытия.
- Закрытие из binding, жеста, фона и нативного iPad sheet проходит через единую обработку. `onDismiss` вызывается один раз при переходе состояния в закрытое, а не после завершения анимации.
- Презентеры имеют собственные идентификаторы: закрытие старого не закрывает новый. Начальный `isPresented == true` обрабатывается при появлении view.
- Прокрутка не конкурирует с жестом перетаскивания на всей поверхности scroll view; доступны ручка и прежний pull-down dismissal.
- `PSButton` вызывает переданный `action`; значения `PreferenceKey` совместимы со строгими проверками Swift 6.
- Добавлены VoiceOver escape action и маркировка модального содержимого; Reduce Motion использует fade вместо slide для перехода.

## Проверка

Сборка библиотеки с SDK iOS 26.4 прошла, в том числе с `SWIFT_VERSION=6 SWIFT_STRICT_CONCURRENCY=complete`. На симуляторе iPhone 17 Pro / iOS 26.4 прошли 5 тестов без ошибок: начальный показ и геометрия в контейнере шириной 280 pt, однократный callback, конфликт презентеров, программное закрытие и быстрое повторное открытие.

Команды из папки пакета:

```sh
xcodebuild -scheme PartialSheet -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
xcodebuild -scheme PartialSheet -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.4' CODE_SIGNING_ALLOWED=NO test
xcodebuild -scheme PartialSheet -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO SWIFT_VERSION=6 SWIFT_STRICT_CONCURRENCY=complete build
```

В Xcode 27 выберите установленный симулятор iOS 27 вместо указанного назначения. Проверьте iPhone portrait/landscape, iPad с изменением размера окна, два окна, фокус TextField и клавиатуру, длинный ScrollView, повторное открытие во время закрытия и обновление родительского состояния при открытом листе. Unit-тесты не заменяют эту проверку взаимодействий.

[Release notes Apple для iOS 27](https://developer.apple.com/documentation/ios-ipados-release-notes/ios-ipados-27-release-notes) требуют для приложения scene-based lifecycle и launch screen. Это настройки приложения, а не Swift Package. В исходном примере уже используются `App`/`WindowGroup` и `INFOPLIST_KEY_UILaunchScreen_Generation = YES`.
