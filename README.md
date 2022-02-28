# Meduza

Это приложение проверяет пришетшие траназкции на AML

[![Ruby](https://github.com/bitzlato/meduza/actions/workflows/ruby.yml/badge.svg)](https://github.com/bitzlato/meduza/actions/workflows/ruby.yml)

Имеет доступ к таблицам: `blockchain_tx`, `deposit`, `withdrawal`

## Развертывание (деплой)

Впервые:

```
cap production systemd:puma:setup
cap production systemd:daemon:setup
cap production systemd:amqp_daemon:setup
cap production master_key:setup
```

Последующие разы:

```
cap production deploy
```

## Как оно работает?

* `AMQP::TransactionChecker` - подписывается на очередь в rabbimq, принимает от
  нее заказы на проверку адресов и кидает их в `PendingAnalysis`
* `Daemons::LegacyPender` каждую секунду пробегается по `blockchain_tx` и создает
  для каждой транзакции новую запись `PendingAnalysis`
* `Daemons::PendingExecutor` каждые 2 секунды пробегается по `PendingAnalysis`,
  проверяет их через `ValegaAnalyzer`, создаёт `TransactionAnalysis` с
  результатами, устанаилвает статус `PendingAnalysis` в `done`.
