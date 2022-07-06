# Миграция конфигурации Terraform провайдера openstack для созданных ресурсов на провайдер от VK Cloud Solutions

## Описание
Миграция ресурсов, ранее созданных в облаке VK Cloud Solutions с помощью openstack terraform провайдера, на Terrafrom провайдер от VK Cloud Solutions. Миграция происходит без пересоздания ресурсов.

## Подготовка

1. Зарегистрируйтесь в VK Cloud Solutions
2. Зайдите в личный кабинет VK CS, перейдите в раздел "Настройки проекта" и сохраните значения для:
- Project ID
- Username
- Region Name
3. Установите [исполняемые файлы Terraform](https://mcs.mail.ru/docs/ru/additionals/terraform/terraform-installation)
4. Перейдите в папку 
5. Добавьте в окружение следующие переменные:
- TF_VAR_password - Пароль для личного кабинете
- TF_VAR_project_id - id проекта
- TF_VAR_region - регион 
- TF_VAR_username - имя пользователя личного кабинета

Используйте файл **add_env_vars.ps1** или **add_env_vars.sh** для автоматизации.

##### Примеры
Linux / MacOS
```bash
export TF_VAR_password="My_Password"
```

Windows (Powershell)
```powershell
$env:TF_VAR_password="My_Password"
```

## Миграция конфигурации и импорт ресурсов
1. Добавьте пустой ресурс в конфигурацию
2. Примените команду импорта ресурса **terraform import vkcs_compute_instance.myVM Resource_ID**
3. Получите конфигурацию импортированного ресурса командой **terraform show**
4. Добавьте конфигурацию в файл для ранее созданного пустого ресурса.
5. Проверьте конфигурацию командой **terraform plan**
6. Повторите для каждого ресурса вашей инфраструктуры

