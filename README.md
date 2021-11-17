# Meduza

Это приложение проверяет пришетшие траназкции на AML

[![Ruby](https://github.com/bitzlato/meduza/actions/workflows/ruby.yml/badge.svg)](https://github.com/bitzlato/meduza/actions/workflows/ruby.yml)

Имеет доступ к таблицам: `blockchain_tx`, `deposit`, `withdrawal`

## Развертывание (деплой)

Впервые:

```
cap production systemd:puma:setup
```

Последующие разы:

```
cap production deploy
```
