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

## Куда отправлять сообщения на проверку транзакции?

https://www.rabbitmq.com/tutorials/tutorial-six-ruby.html

RPC Сообщения отправлять в exchange `meduza` с `route_key=check_transaction`

Пример `payload`:

```
{
  'txid' => 'transaction id',
  'cc_code' => 'BTC',
  'source' => 'belomor'
}
```

Незабываем обавить properties для обратного ответа:

```
:reply_to: Commonly used to name a callback queue.
:correlation_id: Useful to correlate RPC responses with requests.
```

В ответ прилетает следующая структура в exchange `meduza`

```
{
  address_transaction: 'address or transaction id', # Проверенный адрес или транзакция
  cc_code: 'BTC',
  action: 'block'|'pass',
  analysis_result_id: 123, # ID Результатов анализа в базе meduza
}
```

## Как оно работает?

* `AMQP::TransactionChecker` - подписывается на очередь в rabbimq, принимает от
  нее заказы на проверку адресов и кидает их в `PendingAnalysis`
* `Daemons::PendingExecutor` каждые 2 секунды пробегается по `PendingAnalysis`,
  проверяет их через `ValegaAnalyzer`, создаёт `TransactionAnalysis` с
  результатами, устанаилвает статус `PendingAnalysis` в `done`.
