class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @selected_ratings = Movie.rating
    sort = params[:sort]
    unless params[:ratings].nil?
      @selected_ratings = params[:ratings]
      unless @selected_ratings.class == Array
        @selected_ratings = @selected_ratings.keys
      end
      @movies = @movies.where(rating: @selected_ratings)
    end

    @all_ratings = Movie.rating
    unless sort.nil?
      @movies = @movies.order(sort)
    end
    
    unless session[:ratings] == params[:ratings] 
      session[:ratings] = @selected_ratings
      path = movies_path(:sort => params[:sort], :ratings => @selected_ratings)
      redirect_to path
      return
    end
    
    unless session[:sort] == params[:sort] 
      session[:sort] = params[:sort]
      path = movies_path(:sort => params[:sort], :ratings => @selected_ratings)
      redirect_to path
      return
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
