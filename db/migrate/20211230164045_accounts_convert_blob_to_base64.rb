class AccountsConvertBlobToBase64 < ActiveRecord::Migration[6.1]

  def up
    add_column :accounts, :cleartext_password_base64, :mediumtext

    Account.reset_column_information
    Account.find_each do |a|
      password_base64 = Base64.encode64(a.password)
      a.update!(cleartext_password_base64: password_base64)
    end
  end

end
