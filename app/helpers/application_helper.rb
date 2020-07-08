module ApplicationHelper
  def subscripted_resource?(resource)
    @subscripted_resource = resource.has_subscription_from?(current_user)
  end
end
