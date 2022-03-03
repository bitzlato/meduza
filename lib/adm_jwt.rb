class AdmJWT
  ALGO = 'ES256'
  EXPIRE = 10

  def initialize(jwk: JSON.parse(ENV.fetch('P2P_API_ADM_JWK')))
    @jwk = ::JWT::JWK.import jwk
  end

  def encode(payload = {})
    ::JWT.encode merge_claims(payload), @jwk.keypair, ALGO
  end

  def merge_claims(payload)
    payload.reverse_merge(
      iat: Time.now.to_i,
      jti: SecureRandom.hex(10),
      aud: 'adm'
    )
  end
end
