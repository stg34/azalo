require 'openssl'

module Blowfish
  def self.cipher(mode, key, data)
    cipher = OpenSSL::Cipher::Cipher.new('bf-ecb').send(mode)
    cipher.padding = 0
    cipher.key = key
    cipher.update(data) << cipher.final
  end

  def self.encrypt(key, data)
    cipher(:encrypt, key, data)
  end

  def self.decrypt(key, text)
    cipher(:decrypt, key, text)
  end
end
