class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show]
  before_action :set_own_organization, only: [:edit, :update, :destroy]

  def index
    @organizations = current_user.organizations
  end

  def show
  end

  def new
    @organization = Organization.new
  end

  def edit
  end

  def create
    @organization = current_user.own_organizations.build(organization_params)

    if @organization.save
      redirect_to @organization, notice: 'Organization was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: 'Organization was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_url, notice: 'Organization was successfully removed.'
  end

  private

  def set_organization
    @organization = current_user.orgranizations.find(params[:id])
  end

  def set_own_organization
    @organization = current_user.own_orgranizations.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name)
  end
end