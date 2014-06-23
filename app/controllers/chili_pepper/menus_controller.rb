require_dependency "chili_pepper/application_controller"

module ChiliPepper
  class MenusController < ApplicationController
    before_action :authenticate_admin!, except: [:show, :index]
    before_action :menu, except: [:index, :new, :create]

    def index
      menu_type = params[:menu_type] || :food
      if admin_signed_in?
        @menu = Menu.where(menu_type: menu_type).first
        if @menu.present?
          redirect_to @menu
        else
          redirect_to new_menu_path
        end
      else
        @menu = Menu.published.where(menu_type: menu_type).first
        if @menu.present?
          redirect_to menu_path(@menu)
        else
          redirect_to main_app.root_path
        end
      end
    end

    def show
      
      render :layout => 'chili_pepper/menu'
    end

    def new
        @menu = Menu.new()
    end

    def create
      @menu = Menu.new(menu_params)
      if @menu.save
        redirect_to :action => 'show', :id => @menu
        # set_annotations_positions(@menu)
        # clear_menu_caches
      else 
          render :action => 'new'
      end
    end

    def edit
      
    end

    def update
      
      if @menu.update(menu_params)
        redirect_to action: 'show', id: @menu
        # set_annotations_positions(@menu)
        # clear_menu_caches
      else 

          render action: :edit
      end
    end

    def destroy
      @menu.destroy
      redirect_to action: :index
    end

    private

    def menu
      @menu = Menu.friendly.find(params[:id]).decorate
    end

    def menu_params
      params.require(:menu).permit(:name, :description, :menu_type, :availability, :price, :published, :downloadable_pdf, :image)
    end
  end
end
