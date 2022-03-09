class JWTSig
  ALGO = 'ES256'
  EXPIRE = 10

  class << self
    def feeze_sig(jwt: JSON.parse(ENV.fetch('P2P_API_FREEZE_JWK')), claims: {})
      new(jwt: jwt, claims: {})
    end

    def adm_sig(jwt: JSON.parse(ENV.fetch('P2P_API_ADM_JWK')), claims: {})
      new(jwt: jwt, claims: {iat: Time.now.to_i, jti: SecureRandom.hex(10), aud: 'adm'})
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
