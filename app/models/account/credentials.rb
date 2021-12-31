# frozen_string_literal: true

class Account::Credentials < Account
  attr_accessor :cleartext_password, :cleartext_username

  def decrypt(team_password)
    @cleartext_username = 'none' #decrypt_attr(:username, team_password)
    @cleartext_password = decrypt_attr(:cleartext_password_base64, team_password)
  end

  def encrypt(team_password)
    encrypt_username(team_password)
    encrypt_password(team_password)
  end

  private

  def decrypt_attr(attr, team_password)
    crypted_value = Base64.decode64(send(attr))
    return if crypted_value.blank?

    CryptUtils.decrypt_blob(crypted_value, team_password)
  end

  def encrypt_username(team_password)
    return self.username = '' if cleartext_username.blank?

    self.username = CryptUtils.encrypt_blob(cleartext_username, team_password)
  end

  def encrypt_password(team_password)
    return if cleartext_password.blank?

    self.password = CryptUtils.encrypt_blob(cleartext_password, team_password)
  end
end
