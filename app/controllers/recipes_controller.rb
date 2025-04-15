class AuthorizationContext
  attr_reader :user, :office

  def initialize(user, office)
    @user = user
    @office = office
  end
end

class ApplicationPolicy
  attr_reader :request_office, :user, :record

  def initialize(authorization_context, record)
    @user = authorization_context.user
    @office = authorization_context.office
    @record = record
  end

  def index?
    # Your policy has access to @user, @office, and @record.
  end
end



class RecipesController < ApplicationController

  include Pundit

  before_action :set_recipe, only: %i[ show edit update destroy ]

  def pundit_user
    AuthorizationContext.new(current_user, current_office)
  end

  # GET /recipes or /recipes.json
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/1 or /recipes/1.json
  def show
    @ingredient = Ingredient.new(recipe: @recipe)
    end

  # GET /recipes/new
  def new
    @recipe = Recipe.new(creator: current_user)
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes or /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to recipe_url(@recipe), notice: "Recipe was successfully created." }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to recipe_url(@recipe), notice: "Recipe was successfully updated." }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    @recipe.destroy

    respond_to do |format|
      format.html { redirect_to recipes_url, notice: "Recipe was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(:title, :description, :creator_id)
    end
end
