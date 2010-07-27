class UsersController < ApplicationController
  authorize_resource

  before_filter :translate_roles_for_create, :only => [:create, :update]

  @@shown_columns = [:username, :email,   :password, :password_confirmation, :roles]
  @@update_columns = [:username, :email,  :password, :password_confirmation]

  def self.create_columns
    @@create_columns
  end

  active_scaffold :user do |config|
    config.columns =  @@shown_columns
    list.sorting = {:username => 'DESC'}
    config.create.columns = @@create_columns
    config.update.columns = @@update_columns
    list.sorting = { :username => 'DESC' }
    config.columns[:roles].form_ui = :select
    config.columns[:roles].options = {:options => [
      ["Admin",[:admin]],
      ["Reporter",[:reporter]]]}
  end

  def translate_roles_for_create
    if params[:record].key? :roles
      params[:record][:roles]=[params[:record][:roles]]
    end
  end
  #record_select :per_page => 20, :search_on => 'username', :order_by => "username ASC"

  def to_label
    @s="User: "
    if username.nil? || username.empty?
      @s+"<No Name>"
    else
      @s+username
    end
  end


   def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your Profile was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end




end

