# Конвертер валют

Данный проект является учебно-демонстрационным. И показывает возможности реализации клиентских приложений на языке Dart с применением многоуровневой архитектуры. В данном проекте реализованы web-версия и мобильная версия приложения с использованием фреймворков соответственно AngularDart и Flutter.

<img src="layers.png" alt="layers">

# Цели и задачи проекта

## Цели

- Демонстрация возможностей и преимуществ разработки клиентских интерфейсов на языке Dart.
- Обучение приемам разработки клиентских интерфейсов на языке Dart с использованием фреймворков AngularDart и Flutter.

## Задачи:

- Демонстрация возможностей code-sharing при разработке web- и мобильных приложений.
- Демонстрация приемов декомпозиции: выделение классов и компонентов
- Демострация структуры приложений
- Демонстрация выделения бизнес-логики приложения в отдельный пакет и использования этого пакета как в web-версии приложения, так и в мобильной.
- Демонстрация приемов Unit-тестирования

## Структура проекта

Весь проект разбит по пакетам. Каждый пакет находится в соответствующей папке:

- Папка angular содержит пакет с web-версией приложения, написанной с использованием фреймворка AngularDart (Presentation Layer).
- Папка flutter содержит пакет с мобильной версией приложения, написанной с использованием фремворка Flutter (Presentation Layer).
- Папка models содержит пакет с общими моделями данный, которые используются как в web-, так и в мобильном приложениях.
- Папка bloc содержит пакет с компонентами бизнес-логики, используемой так же в web- и мобильном приложениях (Business Logic Layer).
- Папка services содержит пакет с сервисами достпа к данным (Data Access Layer).

## Порядок изучения

1. [Модели](models)
2. [Сервисы](services)
3. [BLoC](bloc)
4. [Web-приложение](angular)
5. [Мобильное приложение](flutter)
