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

    @all_ratings = Movie.all_ratings
    @sorted = params[:sort] || session[:sort]
    
    if params[:sort]
      @sorting = params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      @sorting = session[:sort]
    else
      @sorting = nil
    end
    
    if params[:commit] == "Refresh" and params[:ratings].nil?
      @rate = session[:ratings]
    elsif params[:ratings]
      @rate = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      @rate = session[:ratings]
    else
      @rate = nil
    end
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = @sorted
      session[:ratings] = @rate
      redirect_to :sort => @sorted, :ratings => @rate and return
    end
    
    
    if @sorting and @rate
      @movies = Movie.where(:rating => @rate.keys).order(@sorting).all
    elsif @sorting
      @movies = Movie.order(@sorting).all
    elsif @rate
      @movies = Movie.where(:rating => @rate.keys).all
    else
      @movies = Movie.all
    end
    
    if !@rate
      @rate = Hash.new
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
