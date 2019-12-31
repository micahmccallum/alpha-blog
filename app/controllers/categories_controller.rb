class CategoriesController < ApplicationController

  before_action :set_category, except: [:index, :new, :create]
  before_action :require_admin, except: [:index, :show]

  def index
    @categories = Category.paginate(page: params[:page], per_page: 5)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "You have successfully created a new category"
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def show
    @category_articles = @category.articles.paginate(page: params[:page], per_page: 5)
  end

  def edit
    
  end
  
  def update
    if @category.update(category_params)
      redirect_to(@category)
    else
      render :edit
    end    
  end  

  def destroy    
    @category.destroy
    flash[:success] = "You have successfully deleted a category."
    redirect_to categories_path
  end
    
  private
  def set_category
    @category = Category.find(params[:id])
  end
  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    if !logged_in? || (logged_in? && !current_user.is_admin?)
      flash[:danger] = "Only an admin can perform that action."
      redirect_to categories_path
    end
  end    
end