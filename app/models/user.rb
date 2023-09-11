class User < ApplicationRecord
  has_secure_password

  private

  def down_case
    email.downcase!
  end
end
