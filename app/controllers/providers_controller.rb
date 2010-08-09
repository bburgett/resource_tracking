class ProvidersController < ApplicationController
  authorize_resource :resource => FundingFlow

  before_filter :check_user_has_data_response

  @@columns_for_file_upload = %w[to organization_text project budget spend spend_q4_prev spend_q1 spend_q2 spend_q3 spend_q4]
  map_fields :create_from_file,
    @@columns_for_file_upload,
    :file_field => :file

  def index
    @constraints = { :from => current_user.organization.id } #current_user.organization.id
    @label = "Implementers"
  end

  def create_from_file
    #TODO change application controller so that it's
    # create_from_file method accepts columns and optional
    # block of constraints, instead of using session
    @constraints = { :from => current_user.organization.id } #current_user.organization.id
    super @@columns_for_file_upload, @constraints
  end

  def controller_model_class
    FundingFlow
  end

  def help_model
    ModelHelp.find_by_model_name "Provider"
  end

  def my_AS_controller
    FundingFlowsController
  end
end
