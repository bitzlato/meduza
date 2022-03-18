class JWTSig
  ALGO = 'ES256'

  class << self
    def meduza_sig(jwt: JSON.parse(ENV.fetch('MEDUZA_PRIVATE_KEY')), claims: {})
      new(jwt: jwt, claims: { iss: 'meduza'})
    end
  end

  def initialize(jwk:, claims: {})
    @jwk = ::JWT::JWK.import jwk
    @default_claims = claims
  end

  def encode(payload = {})
    ::JWT.encode merge_claims(payload), @jwk.keypair, ALGO
  end

  def merge_claims(payload)
    payload.reverse_merge(@default_claims)
  end
end
