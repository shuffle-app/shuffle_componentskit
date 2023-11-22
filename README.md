# Shuffle ComponentsKit

## Описание проекта

**shuffle_componentsKit** представляет собой набор страниц(views) пользовательского интерфейса. ComponentsKit содержит готовые к использованию компоненты для проекта shuffle_app.

## Общая структура пакета
![shuffle_components_kit](https://github.com/shuffle-app/shuffle_componentskit/assets/101862863/62f048fe-8cdd-49d8-87a9-358ba5fca390)
## Установка

Для установки componentsKit добавьте его в зависимости файла `pubspec.yaml`:

```yaml
dependencies:
  shuffle_componentsKit: ^latest_version
```

Затем выполните `flutter pub get` для установки пакета.

## Работа с `GlobalConfiguration` 
**GlobalConfiguration** - это инструмент для работы с конфигурацией приложения shuffle_app, он позволяет обрабатывать и предоставлять необходимые данные для компонентов(строки, позицию и т.д). Для тестирование своих компонентов в example проекте можно задать версию конфигурации через _.load(version: '<номер актуальной версии>')_

Для того, чтобы получить необходимые поля для компонента, необходимо:

1. Обратиться к полю content с помощью GlobalConfiguration:
```dart
    final config = GlobalComponent.of(context)?.globalConfiguration.appConfig.content ?? GlobalConfiguration().appConfig.content;
```
2. Обратиться к полю с названием вашей фичи, пример для 'about_user':
```dart
    final ComponentModel model = ComponentModel.fromJson(config['about_user']);
```
3. Обратиться к небходимым параметрам через _model_ из пункта 2:
```dart
    final configSubtitle = model.content.subtitle?[ContentItemType.singleSelect];
    final contentTitle = configSubtitle?.title?[ContentItemType.text]?.properties?.keys.first;
```
