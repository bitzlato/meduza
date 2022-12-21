# frozen_string_literal: true

module Scorechain
  module Analyzer
    module_function

    Error = Class.new(StandardError)
    NoResult = Class.new(Error)

    ANALYZER_NAME = 'Scorechain'

    ANALYSIS_TYPES = [
      ASSIGNED = 'ASSIGNED',
      INCOMING = 'INCOMING',
      OUTGOING = 'OUTGOING',
      FULL     = 'FULL'
    ].freeze

    OBJECT_TYPES = [
      TRANSACTION = 'TRANSACTION',
      ADDRESS     = 'ADDRESS',
      WALLET      = 'WALLET'
    ].freeze

    COIN_TO_BLOCKCHAIN = {
      'BTC'   => 'BITCOIN',
      'BCH'   => 'BITCOINCASH',
      'DASH'  => 'DASH',
      'LTC'   => 'LITECOIN',
      'ETH'   => 'ETHEREUM',
      'USDT'  => 'ETHEREUM',
      'USDC'  => 'ETHEREUM'
    }.freeze

    RISK_LEVEL = {
      'CRITICAL_RISK' => 3,
      'HIGH_RISK'     => 2,
      'MEDIUM_RISK'   => 2,
      'LOW_RISK'      => 1,
      'NO_RISK'       => 1
    }.freeze

    DANGER_RISK_LEVEL = RISK_LEVEL['CRITICAL_RISK']

    def pass?(analysis_result)
      !block?(analysis_result)
    end

    def block?(analysis_result)
      analysis_result.risk_level >= DANGER_RISK_LEVEL
    end

    def analize_wallet(wallet:, coin:, blockchain: nil, analysis_type: ASSIGNED)
      analize(analysis_type: analysis_type, object_type: WALLET, object_id: wallet, coin: coin, blockchain: blockchain, analysis_result_type: :address)
    end

    def analize_transaction(txid:, coin:, blockchain: nil, analysis_type: INCOMING)
      analize(analysis_type: analysis_type, object_type: TRANSACTION, object_id: txid, coin: coin, blockchain: blockchain, analysis_result_type: :transaction)
    end

    def analize(analysis_type:, object_type:, object_id:, coin:, blockchain: nil, analysis_result_type:)
      params = {
        analysis_type: analysis_type,
        object_type: object_type,
        object_id: object_id,
        blockchain: (blockchain || lookup_blokchain_by_coin(coin)),
        coin: coin
      }

      response = JSON.parse(Scorechain.client.scoring_analysis(**params).body)

      analysis = response.dig('analysis', analysis_type.downcase)

      if analysis['hasResult']
        result = analysis['result']

        AnalysisResult.create!(
          analyzer: ANALYZER_NAME,
          address_transaction: object_id,
          raw_response: response,
          cc_code: coin,
          type: analysis_result_type,
          risk_level: RISK_LEVEL[result['severity']],
          # score - это risk_level в процентах,
          # тогда risk_confidence обратная величина
          # Например:
          # score(risk_level) = 0.75, тогда risk_confidence = 0.25,
          # score + risk_confidence == 1
          risk_confidence: (100 - result['score']) / 100.0
        )
      else
        Scorechain.logger.info { "Can't analysis #{object_type}=#{object_id}: No result" }
        raise NoResult, 'No result'
      end
    rescue ScorechainClient::NotFound => e
      Scorechain.logger.info { "Analysis not found for #{object_type}=#{object_id}: #{e.message}" }
      raise NoResult, e.message
    rescue ScorechainClient::UnprocessableEntity => e
      Scorechain.logger.info { "Can't process #{object_type}=#{object_id}: #{e.message}" }
      AnalysisResult.create!(
        analyzer: ANALYZER_NAME,
        address_transaction: object_id,
        raw_response: response,
        cc_code: coin,
        type: 'error'
      )
    end

    def lookup_blokchain_by_coin(coin)
      COIN_TO_BLOCKCHAIN.fetch(coin)
    end

    def analyzable_coin?(coin)
      COIN_TO_BLOCKCHAIN.keys.include?(coin)
    end
  end
end
