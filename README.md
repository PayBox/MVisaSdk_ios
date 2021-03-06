**PBMvisaSdk SDK (Swift)**

PBMvisaSdk SDK - это библиотека позволяющая проводить оплату Mvisa через API PayBox. 
Библиотека работает совместно с [SDK_iOS-input-](https://github.com/PayBox/SDK_iOS-input-)

**Установка:**

1. Установите "Cocoapods" - менеджер зависимостей проектов Cocoa, с помощью команды:
```
        $ gem install cocoapods
```
2. Чтобы интегрировать "PBMvisaSdk" в проект Xcode с использованием "Cocoapods", создайте в корне проекта файл "Podfile" и вставьте в файл следующую команду:
```
        source 'https://github.com/CocoaPods/Specs.git' 
        platform :ios, '12.1';
        use_frameworks!
        target 'Project name' do
        pod 'PayBoxSdk', :git => 'https://github.com/PayBox/SDK_iOS-input-.git', :submodules => true
        pod 'PBMvisaSdk', :git => 'https://github.com/PayBox/MVisaSdk_ios.git', :submodules => true
        end
```
3. Затем выполните след. команду:
```       
        $ pod install
```

**Инициализация SDK:**
```
        import PayBoxSdk

        let builder = PBHelper.Builder(secretKey: String, merchantId: String)
```
Выбор платежной системы:
```
        builder.paymentSystem(system: .EPAYWEBKZT)
```
Выбор валюты платежа:
```
        builder.paymentCurrency(currency: .KZT)
```
Дополнительная информация пользователя, если не указано, то выбор будет предложен на сайте платежного гейта:
```
        builder.userInfo(email: string, phoneNumber: String)
```
Активация автоклиринга:
```
        builder.autoClearing(enabled: true)
```
Для активации режима тестирования:
```
        builder.testMode(enabled: true)
```
Для передачи информации от платежного гейта:
```
        builder.feedBackUrl(checkUrl: String, resultUrl: String, refundUrl: String, captureUrl: String, method: REQUEST_METHOD)
```
Время (в секундах) в течение которого платеж должен быть завершен, в противном случае, при проведении платежа, PayBox откажет платежной системе в проведении (мин. 300 (5 минут), макс. 604800 (7 суток), по умолчанию 300):
```
        builder.paymentLifeTime(lifetime: 300)
```

**Инициализация параметров:**
```
        builder.build()
```

**Работа с SDK:**

Для связи с SDK,  имплементируйте в UIViewController -> PBMVisaDelegate:
В методе viewDidLoad() добавьте:
```
        MVisahelper.instance.delegate = self
```
**Для вызова сканера**
```
        MVisahelper.instance.initScanner(userId: text)
```
В ответ откроется "QR сканер", наведите камеру смартфона на QR MVisa, после сканирования "QR сканер" закроется и в вашем viewController вызовется функция:
```
        func onQrDetected(mVisa: MVisa?, cards: [Card]?)
```
Во входных параметрах:
        1. mVisa - содержит сумму платежа, валюта платежа, имя мерчанта и номер мерчанта в системе MVisa;
        2. cards - содержит массив доступных карт пользователя, если пользователь не добавлял карты то вместо массива будет "null";

Данные параметры вы сможете отобразить на вашей странице "Подтверждения платежа"


**Подтверждение платежа**

После подтверждения платежа пользователем вызовите метод:
```        
        MVisahelper.instance.initPayment(orderId: String, cardId: String?, description: String, extraParams: [String:String]?) //Если пользователь не добавлял карт то вместо "cardId" укажите nil
```
1. Если пользователь не добавлял карт то в ответ откроется "WebView" с платежной страницей, после оплаты карта будет сохранена в системе PayBox.
2. Если пользователь добавил карту ранее то пройдет платеж по "Рекуррентному профилю".

После оплаты в вашем "viewController" вызовется функция:
```
        func onQrPayment(response: Response)
```

В случае ошибки или неуспешного платежа вызовется метод:
```
        func onQrError(error: ErrorResponse)
```

**Описание некоторых входных параметров**

1. orderId - Идентификатор платежа в системе продавца. Рекомендуется поддерживать уникальность этого поля.
2. amount - Сумма платежа
3. merchantId - Идентификатор продавца в системе PayBox. Выдается при подключении.
4. secretKey - Платежный пароль, используется для защиты данных, передаваемых системой PayBox магазину и магазином системе Paybox
5. userId - Идентификатор клиента в системе магазина продавца.
6. paymentId - Номер платежа сформированный в системе PayBox.
7. description - Описание товара или услуги. Отображается покупателю в процессе платежа.
8. extraParams - Дополнительные параметры продавца. Имена дополнительных параметров продавца должны быть уникальными. 
9. checkUrl - URL для проверки возможности платежа. Вызывается перед платежом, если платежная система предоставляет такую возможность. Если параметр не указан, то берется из настроек магазина. Если параметр установлен равным пустой строке, то проверка возможности платежа не производится.
10. resultUrl - URL для сообщения о результате платежа. Вызывается после платежа в случае успеха или неудачи. Если параметр не указан, то берется из настроек магазина. Если параметр установлен равным пустой строке, то PayBox не сообщает магазину о результате платежа.
11. refundUrl - URL для сообщения об отмене платежа. Вызывается после платежа в случае отмены платежа на стороне PayBoxа или ПС. Если параметр не указан, то берется из настроек магазина.
12. captureUrl - URL для сообщения о проведении клиринга платежа по банковской карте. Если параметр не указан, то берется из настроек магазина.
13. REQUEST_METHOD - GET, POST или XML – метод вызова скриптов магазина checkUrl, resultUrl, refundUrl, captureUrl для передачи информации от платежного гейта.
