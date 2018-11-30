<h1 align="center">
  <br>
  StarWarsExplorer
  <br>
</h1>

<h4 align="center">Тестовое задание для кандидатов в компании Arcsinus</h4>

<h1 align="center">
<img src="https://raw.githubusercontent.com/moridaffy/StarWarsExplorer/master/Extra/screen_list.png" alt="Список персонажей" width="250"> <img src="https://raw.githubusercontent.com/moridaffy/StarWarsExplorer/master/Extra/screen_details.png" alt="Детальная информация о персонаже" width="250">
</h1>

<p align="center">
  <a href="#Информация">Информация</a> •
  <a href="#Как-запустить">Как запустить</a> •
  <a href="#Разработчик">Разработчик</a>
</p>

## Информация
StarWarsExplorer - простое приложение, позволяющее пользователю просматривать список персонажей звездных воинов, а также выполнять поиск среди них. Приложение автоматически сохраняет всю загруженную информацию в локальнюу БД, чтобы у пользователя был доступ к этим данным даже при отсутствии подключения к интернету. Данные из локальной БД также можно вручную удалить (как каждый элемент выборочно, так и все сразу)

* Информация о фильмах загружаются при помощи публичного  <a href="https://swapi.co">The Star Wars API'a</a>
* Приложение написано на Swift'e и использует следующие сторонние библиотеки: <a href="https://github.com/realm/realm-cocoa">Realm</a> для хранения данных в локальной БД и <a href="https://github.com/Alamofire/Alamofire">Alamofire</a> для выполнения сетевых запросов к API
* Интерфейсы построены в IB с использованием AutoLayout'a


## Как запустить
Чтобы приложение начало работу после fork'a/загрузки, необходимо выполнить следующие действия:
* Перейдите в директорию проекта и запустите следующую команду для установки вспомогательных библиотек (необходимо наличие <a href="https://cocoapods.org">CocoaPods</a>
```
pod install
```
* Открыть файл проекта в XCode (с расширением .workspace)
* Скомпилировать и запустить проект на симуляторе или физическом устройстве

## Разработчик
<a href="http://mskr.name">Веб-сайт</a>  
<a href="http://vk.com/morimax">ВК</a>  
<a href="http://t.me/moridaffy">Telegram</a>  
<a href="mailto:dev@mskr.name">E-Mail</a>
