# Как разворачивать приложения в кластере Kubernetes в интеграции с DBaaS с помощью Terrafrom провайдером от VC Cloud Solutions

## Описание
Пример автоматического разворачивания приложения в инфраструктуре облака VK Cloud Solutions с использованием Kubernets aaS и DBaaS. Для примера используется Wordpress, который запускается в кластере Kubernetes с одним мастером и группой рабочих нод. Для нод-группы включено автомасштабирование. Wordpress подключается к базе данных создаваемой в инстансе MySql облачного сервиса DBaaS.

## Подготовка

1. Зарегистрируйтесь в VK Cloud Solutions
2. Зайдите в личный кабинет VK CS, перейдите в раздел "Настройки проекта" и сохраните значения для:
- Project ID
- Username
- Region Name
3. Установите [исполняемые файлы Terrafrom](https://mcs.mail.ru/docs/ru/additionals/terraform/terraform-installation)

## Добавление переменных окружения.


## Разворачивание приложения через Terrafrom 
1. Перейдите в папку k8sdbass
2. Откройте и заполните файл variables.tf
3. Откройте командную строку
4. Добавьте в окружение следующие переменные:
- TF_VAR_password - Пароль для личного кабинете
- TF_VAR_project_id - id проекта
- TF_VAR_region - регион 
- TF_VAR_username - имя пользователя личного кабинета
- TF_VAR_DB_USER_PASSWORD - Пароль для пользователя базы данных. Пароль должен быть сложным и минимум 16 символов

##### Примеры
Linux / MacOS
```bash
export TF_VAR_password="My_Password"
```

Windows (Powershell)
```powershell
$env:TF_VAR_password="My_Password"
```


3. Запустите создание инфраструктуры командой
```bash
terraform apply
```
4. Подтвердите создание введя yes.
5. После завершения внешний IP адрес, для настройки Wordpress, будет выведен в консоль в переменной **external_ip**
6. Kubeconfig для подключения к кластеру будет сохранен в файле **kube_config.yaml**