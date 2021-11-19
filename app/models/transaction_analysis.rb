class TransactionAnalysis < ApplicationRecord
  upsert_keys [:txid]
end
