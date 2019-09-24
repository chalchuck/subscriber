module Users
  module DeviseUser
    extend ActiveSupport::Concern

    included do
      devise :registerable,
             :recoverable,
             :rememberable,
             :confirmable,
             :trackable,
             :validatable,
             :lockable,
             :timeoutable,
             :database_authenticatable,
             :unlock_strategy => [:time, :none],
             :lock_strategy => [:failed_attempts, :none]
    end

    module ClassMethods
    end
  end
end
