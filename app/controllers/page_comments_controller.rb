class PageCommentsController < ApplicationController
  def index
    @constraints = {}
    @constraints[:commentable_id] = params[:id] if params[:id]
    @constraints[:commentable_type] = params[:type] if params[:type]
    render :template => 'comments/index'
  end
end
