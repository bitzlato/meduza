class SetupPublic < ActiveRecord::Migration[6.1]
  def change
    return unless ENV.true? 'SETUP_PUBLIC_SCHEME'

    execute File.read Rails.root.join('db/public.structure.sql')
  end
end
