class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    @sort = params[:sort] || session[:sort]
    if !(Movie.column_names.include?(@sort)) 
      @sort = session[:sort]
    end
    session[:sort] = @sort 
    @all_ratings = Movie.all_ratings
    params[:ratings].nil? ? @selected_ratings = session[:ratings] : @selected_ratings = params[:ratings].keys
    # @selected_ratings.each do |rate|
    #   if !(@all_ratings.include?(rate)) 
    #     @selected_ratings = session[:ratings];
    #   end
    # end
    session[:ratings] = @selected_ratings
    @movies = Movie.where(rating: @selected_ratings).order(@sort)
    @hilite = @sort
    puts "params[:sort]*********************** " + params[:sort].inspect
    puts "params[:ratings]******************** " + params[:ratings].inspect
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end