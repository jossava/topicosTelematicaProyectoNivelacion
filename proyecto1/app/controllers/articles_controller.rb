class ArticlesController < ApplicationController
	before_action :authenticate_user!, except: [:show, :index]
	before_action :set_article, except: [:new, :create, :index]

	#GET /articles
	def index
		word = "%#{params[:keyword]}%"
		if !word.nil? then 
			@articles = Article.where("title LIKE ? OR body LIKE ?", word, word)
		else
			# Todos los registros SELECT * FROM articles
			@articles = Article.all
		end
	end
	
	#GET /articles/:id
	def show
		# Encontrar un registro por id
		#@article = Article.find(params[:id]) ya está en el callback set_article
		#Where
		#Article.Where("id = ?", params[:id])
		@article.update_visits_count
		@comment = Comment.new
	end
	
	#GET /articles/new
	def new
		@article = Article.new
	end
	
	#POST /articles
	def create
		#INSERT INTO articles ...
		# @article = Article.new(title: params[:article][:title], 
		#						body: params[:article][:body])
		@article = current_user.articles.new(article_params)
		#Este es un new y un save a la vez
		#@article = Article.create(title: params[:article][:title], 
		#						body: params[:article][:body])
		#@article.valid?
		if @article.save
			redirect_to @article
		else
			render :new
		end
	end
	#DELETE /articles/:id
	def destroy
		#DELETE FROM articles
		#@article = Article.find(params[:id]) ya está en el callback set_article
		@article.destroy # Eliminar objeto de la base de datos
		redirect_to articles_path
	end

	#POST /articles/:id
	def update
		#UPDATE
		#@article.update_attributes({title: "Nuevo título"})
		#@article = Article.find(params[:id]) ya está en el callback set_article
		if @article.update(article_params)
			redirect_to @article
		else
			render :edit
		end
	end

	def edit
		#@article = Article.find(params[:id]) ya está en el callback set_article
	end

	private

	def set_article
		@article = Article.find(params[:id])
	end

	def validate_user
		redirect_to new_user_session_path, notice: "Necesitas iniciar sesión."
	end

	def article_params
		params.require(:article).permit(:title, :body, :visibility, :image)
	end
end