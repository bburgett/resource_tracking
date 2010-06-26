class DataRequestsController < ApplicationController
  def projects
    render :template => 'projects/index'
  end

  def funding_sources
    @constraints = { :to => Organization.last } #current_user.organization
    render :template => 'funding_flows/index'
  end

  def providers
    @constraints = { :from => Organization.last } #current_user.organization
    render :template => 'funding_flows/index'
  end

  def activities
    render :template => 'activities/index'
  end

end
