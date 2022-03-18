# По исторической части `blockchain_tx`

1. [x] Разбить входящие/исходящие.
2. [ ] Грязные исходящие проверяем по адресам-приемникам. Помечаем
   пользователей.
3. [ ] TODO по коду

## Refactor

0. [ ] Установить analysis_result для transaction_analysis и сделать not null
1. [x] Отправлять на проверку через rabbitmiq LegacyPender отправляет событие в
   кролика, TransactionChecker принимает
2. [ ] Remove TransactionSource
