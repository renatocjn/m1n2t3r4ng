class User < ActiveRecord::Base
    attr_accessor :update_password
    
    has_secure_password
    validates :name, :login, :email, presence: true
    validates :login, :email, uniqueness: true
    
    after_initialize do
        self.update_password ||= false
    end
end
