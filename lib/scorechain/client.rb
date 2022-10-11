module Scorechain
  class Client
    Error               = Class.new(StandardError)
    ResponseError       = Class.new(Error)
    BadRequest          = Class.new(ResponseError)
    Unauthorized        = Class.new(ResponseError)
    NotFound            = Class.new(ResponseError)
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
        when 500
          raise InternalServerError, env[:response_body]
        else
          raise ResponseError, env[:response_body]
        end
      end
    end

    def initialize(url: ENV.fetch('SCORECHAIN_API_URL', 'https://beta.api.scorechain.com'),
                  logger: Logger.new(Rails.application.root.join('log/scirechain_client.log')))
      @url    = url
      @logger = logger
      @logger.level = Logger::DEBUG
    end

    # https://beta.app.scorechain.com/tech-doc/#/Blockchain%20data/get_blockchains__blockchain__addresses__address_
    def scoring_analysis(analysis_type:, object_type:, object_id:, blockchain:, coin:)
      conn.post('/scoringAnalysis',
                analysisType: analysis_type,
                objectType: object_type,
                objectId: object_id,
                blockchain: blockchain,
                coin: coin)
    end

    private

    def conn
      Faraday.new(url: @url) do |c|
        c.use CustomErrors
        c.use Faraday::Response::Logger
        c.headers = {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
        }
        c.request :url_encoded
        c.request :curl, @logger, :debug
        c.response :detailed_logger, @logger if ENV.true?('LOG_API_RESPONSE')
      end
    end
  end
end
