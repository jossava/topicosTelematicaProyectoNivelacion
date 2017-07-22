class ArticlesController < ApplicationController
	
	#GET /articles
	def index
		# Todos los registros SELECT * FROM articles
		@articles = Article.all
	end
	
	#GET /articles/:id
	def show
		# Encontrar un registro por id
		@article = Article.find(params[:id])
		#Where
		#Article.Where("id = ?", params[:id])
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
		@article = Article.new(article_params)
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
		@article = Article.find(params[:id])
		@article.destroy # Eliminar objeto de la base de datos
		redirect_to articles_path
	end

	#POST /articles/:id
	def update
		#UPDATE
		#@article.update_attributes({title: "Nuevo título"})
		@article = Article.find(params[:id])
		if @article.update(article_params)
			redirect_to @article
		else
			render :edit
		end
	end

	def edit
		@article = Article.find(params[:id])
	end

	private

	def article_params
		params.require(:article).permit(:title, :body)
	end
end