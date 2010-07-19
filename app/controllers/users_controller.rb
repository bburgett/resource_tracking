class UsersController < ApplicationController

  @@shown_columns = [:username, :email,   :password, :password_confirmation, :roles]
  @@create_columns = [:username, :email,  :password, :password_confirmation]

  def self.create_columns
    @@create_columns
  end

  active_scaffold :user do |config|
    config.columns =  @@shown_columns
    list.sorting = {:username => 'DESC'}
    config.create.columns = @@create_columns
    config.update.columns = config.create.columns
    list.sorting = { :username => 'DESC' }
  end

  record_select :per_page => 20, :search_on => 'username', :order_by => "username ASC"

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

