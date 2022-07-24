class AccountSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash

  attributes :id, :code, :status, :score, :user
end
