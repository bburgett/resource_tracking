class DataRequestsController < ApplicationController
  def projects
    render :template => 'projects/index'
  end

  def funding_sources
    @label = "Funding Sources"
    @constraints = { :to => Organization.last.id } #current_user.organization
    render :template => 'funding_flows/index'
  end

  def providers
    @label = "Subcontractors / Providers"
    @constraints = { :from => Organization.last.id } #current_user.organization
    render :template => 'funding_flows/index'
  end

  def activities
    render :template => 'activities/index'
  end

end
