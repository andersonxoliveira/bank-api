class AccountSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash

  attributes :id, :status, :score, :client
end