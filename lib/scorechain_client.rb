class ScorechainClient
  Error               = Class.new(StandardError)
  ResponseError       = Class.new(Error)
  BadRequest          = Class.new(ResponseError)
  Unauthorized        = Class.new(ResponseError)
  NotFound            = Class.new(ResponseError)
  TooManyRequests      = Class.new(ResponseError)
  UnprocessableEntity = Class.new(ResponseError)
  InternalServerError = Class.new(ResponseError)

  class CustomErrors < Faraday::Response::Middleware
    def on_complete(env)
      return if env.response.success?

      case env[:status]
      when 400
        raise BadRequest, env[:response_body]
      when 401
        raise Unauthorized, env[:response_body]
      when 404
        raise NotFound, env[:response_body]
      when 422
        raise UnprocessableEntity, env[:response_body]
      when 429
        raise TooManyRequests, env[:response_body]
      when 500
        raise InternalServerError, env[:response_body]
      else
        raise ResponseError, env[:response_body]
      end
    end
  end

  def initialize(url: ENV.fetch('SCORECHAIN_API_URL', 'https://api.scorechain.com/v1/'),
                api_key: ENV.fetch('SCORECHAIN_API_KEY'),
                logger: Logger.new(Rails.application.root.join('log/scirechain_client.log')))
    @url    = url
    @logger = logger
    @logger.level = Logger::DEBUG
    @api_key = api_key
  end

  # https://tech-doc.api.scorechain.com/#/Scoring/post_scoringAnalysis
  def scoring_analysis(analysis_type:, object_type:, object_id:, blockchain:, coin:)
    conn.post('scoringAnalysis',
              {analysisType: analysis_type,
              objectType: object_type,
              objectId: object_id,
              blockchain: blockchain,
              coin: coin}.to_json)
  end

  def blockchain_transaction(blockchain:, txid:)
    conn.get("blockchains/#{blockchain}/transactions/#{txid}")
  end

  private

  def conn
    Faraday.new(url: @url) do |c|
      c.request :curl, @logger, :debug
      c.use CustomErrors
      c.use Faraday::Response::Logger
      c.headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
        'X-API-KEY' => @api_key
      }
      c.request :url_encoded
      c.response :detailed_logger, @logger if ENV.true?('LOG_API_RESPONSE')
    end
  end
end

