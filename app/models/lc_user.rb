require 'digest/sha2'
require "base64"

class LcUser
  include Mongoid::Document
  store_in collection: "User"
  field :email, type: String
  field :username, type: String
  field :level, type: String
  field :password, type: String
  field :salt, type: String
  field :createdAt, type: Time

  LEVEL_MAP = {"新手" => "10", "预科" => "15", "大一" => "20", "大二" => "30", "大三" => "40", "大四" => "50",
               "实习学长" => "60", "认证学长" => "70", "资深学长" => "80"}

  def generate_encrypted_default_password
    hasher = Digest::SHA512.new
    hasher.reset
    hasher.update salt
    hasher.update User::DEFAULT_PASSWORD

    hv = hasher.digest

    encrypted_pwd = Base64.encode64(hashme(hasher,hv))
    self.password = encrypted_pwd.gsub(/\n/,'')
  end

  private

  def hashme(hasher, hv)
    512.times do
      hasher.reset
      hv = hasher.digest hv
    end
    hv
  end
end
