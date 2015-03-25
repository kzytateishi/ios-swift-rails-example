module Entity
  module V1
    class UsersEntity < Grape::Entity
      expose :id, :name, :email
    end
  end
end
