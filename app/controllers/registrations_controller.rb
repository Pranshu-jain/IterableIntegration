class RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        # Create or update user in Iterable
        IterableService.create_or_update_user(resource)
      end
    end
  end
end
