# topicosTelematicaProyectoNivelacion

# rubyArticulosEM
## By: Juan Fernando Ossa Vásquez - jossava@eafit.edu.co

# DEVELOPMENT::

## 1. Creating the project1 Application

        $ rails new proyecto1

## 2. Starting up the WebApp Server

        $ rails server

* Open browser: http://localhost:3000

## 3. Main page: "Hello World"

        $ rails generate controller Welcome index

        edit:
        app/views/welcome/index.html.erb
        config/routes.rb

## 4. Create REST routes        

* edit: config/routes.rb
      # scope '/' -> run http://server:3000 (native) or http://server (inverse proxy or passenger)
      # scope '/prefix_url' -> run http://server:3000/prefix_url or http://server/prefix_url (inverse proxy or passenger).
      # ej: http://10.131.137.236/articles/
        Rails.application.routes.draw do
          resources :articles do
            #resources :comments, only: [:create, :update]
          end
          devise_for :users
          root 'welcome#index'
        end     

* run:    
        $ rake routes

* output:

                  Prefix Verb   URI Pattern                                  Controller#Action
                articles GET    /articles(.:format)                          articles#index
                         POST   /articles(.:format)                          articles#create
             new_article GET    /articles/new(.:format)                      articles#new
            edit_article GET    /articles/:id/edit(.:format)                 articles#edit
                 article GET    /articles/:id(.:format)                      articles#show
                         PATCH  /articles/:id(.:format)                      articles#update
                         PUT    /articles/:id(.:format)                      articles#update
                         DELETE /articles/:id(.:format)                      articles#destroy
        new_user_session GET    /users/sign_in(.:format)                     devise/sessions#new
            user_session POST   /users/sign_in(.:format)                     devise/sessions#create
    	destroy_user_session DELETE /users/sign_out(.:format)                devise/sessions#destroy
       new_user_password GET    /users/password/new(.:format)                devise/passwords#new
      edit_user_password GET    /users/password/edit(.:format)               devise/passwords#edit
           user_password PATCH  /users/password(.:format)                    devise/passwords#update
                         PUT    /users/password(.:format)                    devise/passwords#update
                         POST   /users/password(.:format)                    devise/passwords#create
		cancel_user_registration GET    /users/cancel(.:format)      devise/registrations#cancel
   	new_user_registration GET    /users/sign_up(.:format)                devise/registrations#new
  	edit_user_registration GET    /users/edit(.:format)                  devise/registrations#edit
       	user_registration PATCH  /users(.:format)                            devise/registrations#update
                         PUT    /users(.:format)                             devise/registrations#update
                         DELETE /users(.:format)                             devise/registrations#destroy
                         POST   /users(.:format)                             devise/registrations#create
                    root GET    /                                            welcome#index

## 5. Generate controller for 'articles' REST Services

        $ rails generate controller Articles

* modify: app/controllers/articles_controller.rb
* create: app/views/articles/new.html.erb    

* run: http://localhost:3000/articles/new    

## 6. Create a FORM HTML to enter data for an article

* edit: app/views/articles/new.html.erb:

      <% name ||= "Crear" %>
        <h1><%= name %> artículo</h1>
        <%= form_for(@article) do |f| %>
                <% @article.errors.full_messages.each do |message| %>
                        <div class="be-rederror white top-space"> 
                                * <%= message %>
                        </div>
                <%end%>
                <div class="field">
                        <%= f.text_field :title, placeholder: "Título", class:"form-control" %>
                </div>
                <div class="field">
                        Visibilidad - <%= f.select :visibility, options_for_select(["publico","privado","compartido"]) %>
                </div>
                <div class="field">
                        <%= f.text_area :body, placeholder: "Escribe aquí el artículo", style: "height:250px;", class:"form-control" %>
                </div>
                <div class="field">
                        Imagen: <%= f.file_field :image %>
                </div>
                <div class="field">
                        <%= f.submit "Publicar", class:"btn be-red white" %>
                </div>
        <%end%>

* modify: app/views/articles/show.html.erb:

      <div class="center-article-info", style="background-image: url("fondo.jpg");">
		<h1><%= @article.title %></h1>
		<%if !@article.user.nil? %>
			<p>
				Autor: <%= @article.user.email %>
			</p>
		<%else%>
			<p>
				Autor anónimo.
			</p>
			<%end%>
			<p>
				Visitas: <%= @article.visits_count %>
			</p>
			<p>
				Visibilidad: <%= @article.visibility %>
			</p>
			<p>
				Fecha y hora de creación: <%= @article.created_at %>
			</p>
			<p>
				Descripción: <%= @article.body %>
			</p>
			<div class="field">
				<%= image_tag @article.image.url(:medium) %>
			</div>
			<br>
			<br>
			<% if !@article.user.nil? and @article.user == current_user %>
			<div class="actions">
				<strong><%= link_to "Editar", edit_article_path(@article), class:"btn be-red white" %></strong>
				<strong><%= link_to "Eliminar", @article, method: :delete, class:"btn white", style:"background-color: #E74C3C; " %></strong>
			</div>
			<%end%>
			<br>
			<br>
		</div>

      POST method and require 'create' action.

* add 'create' action to ArticlesController:

        class ArticlesController < ApplicationController
          def new
          end

          def create
		@article = current_user.articles.new(article_params)
	   end
        end     

## 7. Creating the Article model

      $ rails g model Article title:string body:text visits_count:integer visibility:string

* look db/migrate/20170718222157_create_articles.rb:

      class CreateArticles < ActiveRecord::Migration[5.0]
          def change
            create_table :articles do |t|
              t.string :title
              t.text :body
              t.integer :visits_count
              t.string :visibility

              t.timestamps null: false
            end
          end
        end

## 8. Running a Migration

run:

    $ rake db:migrate

## include postgresql in test and production environment:

(Warning: install postgresql server on host)

* Modify Gemfile

      # Use Postgresql as the database for Active Record
      gem 'pg'

* Modify config/database.yml:

      test:
          adapter: postgresql
          database: bd_test
          user: jossava
          password: jossava
          host: localhost
          port: 5432
          pool: 5
          pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
          timeout: 5000

      production:
          adapter: postgresql
          database: bd_production
          user: jossava
          password: jossava
          host: localhost
          port: 5432
          pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
          timeout: 5000    

* Drop, Create and migrate new database:

          $ rake db:drop db:create db:migrate

## 9. Saving data in the controller

* Open app/controllers/articles_controller.rb

      def create
        @article = Article.new(params[:article])
        if @article.save
                redirect_to @article
        else
                render :new
        end
      end

* fix:

      before_action :set_article, except: [:new, :create, :index]
      
      private
      def article_params
        params.require(:article).permit(:title, :body, :visibility, :image)
      end
  

## 10. Showing Articles

* Route:

      article GET    /articles/:id(.:format)      articles#show

* Controller: add action in app/controllers/articles_controller.rb

      def show
        @article = Article.find(params[:id])
      end

* View: create a new file app/views/articles/show.html.erb

      		<h1><%= @article.title %></h1>
		<%if !@article.user.nil? %>
			<p>
				Autor: <%= @article.user.email %>
			</p>
		<%else%>
			<p>
				Autor anónimo.
			</p>
		<%end%>
		<p>
			Visitas: <%= @article.visits_count %>
		</p>
		<p>
			Visibilidad: <%= @article.visibility %>
		</p>
		<p>
			Fecha y hora de creación: <%= @article.created_at %>
		</p>
		<p>
			Descripción: <%= @article.body %>
		</p>
		<div class="field">
			<%= image_tag @article.image.url(:medium) %>
		</div>  

# 11. Listing all articles

* Route:

      articles GET    /articles(.:format)          articles#index

* Controller: add action in app/controllers/articles_controller.rb

      def index
         @articles = Article.all
      end
      
* Fix at app/controllers/articles_controller.rb to search articles

		def index
			word = "%#{params[:keyword]}%"
			if !word.nil? then 
				@articles = Article.where("title LIKE ? OR body LIKE ?", word, word)
			else
				# Todos los registros SELECT * FROM articles
				@articles = Article.all
			end
		end

* View: create a new file app/views/articles/index.html.erb

	      <%= form_tag "", method: :get, style:"text-align:right; width=300px;" do %>
			<%= text_field_tag :keyword, nil, placeholder: "Qué artículo estás buscando", style:"width:300px;margin:15px;height:20px;"%>
			<%= content_tag :button, type: :submit, class:"be-red white", style:"height:30px;" do%>
				Buscar
			<%end%>
		<%end%>

		<div>
			<br>
			<%= link_to "Crear nuevo articulo", new_article_url, class:"btn be-red white center-btn top-space" %>
			<br><br>
		</div>

		<div class="row">
			<% @articles.each do |article| %>
				<%if !current_user.nil? and article.visibility == "compartido"%>
				<div class="col-md-4">
					<div class="relative text-center">
						<h2><%= link_to article.title, article %></h2>
					</div>
					<div class="box relative  article-height">
						<div class="absolute article-height background-image" style="background:url(<%= article.image.url(:medium) %>); top: 0px; left: 10%; width: 80%;">
						</div>
						<div class="absolute article-height background-image" style="background:rgba(0,0,0,0.5); top: 0px; left: 10%; width: 80%;">
						</div>
					</div>
					<p> <%= article.body.truncate(50) %></p>
					</div>
				<%end%>
				<%if article.visibility == "publico"%>
				<div class="col-md-4">
					<div class="relative text-center">
						<h2><%= link_to article.title, article %></h2>
					</div>
					<div class="box relative article-height">
						<div class="absolute article-height background-image" style="background:url(<%= article.image.url(:medium) %>); top: 0px; left: 10%; width: 80%;">
						</div>
						<div class="absolute article-height background-image" style="background:rgba(0,0,0,0.5); top: 0px; left: 10%; width: 80%;">
						</div>
					</div>
					<p> <%= article.body.truncate(50) %> </p>
					</div>
				<%end%>
				<%if article.visibility == "privado" && article.user==current_user%>
				<div class="col-md-4">	
					<div class="relative text-center">
						<h2><%= link_to article.title, article %></h2>
					</div>
					<div class="box relative  article-height">
						<div class="absolute article-height background-image" style="background:url(<%= article.image.url(:medium) %>); top: 0px; left: 10%; width: 80%;">
						</div>
						<div class="absolute article-height background-image" style="background:rgba(0,0,0,0.5); top: 0px; left: 10%; width: 80%;">
						</div>
					</div>
					<p> <%= article.body.truncate(50) %></p>
					</div>
				<%end%>
			<%end%>
		</div>

# 12. Adding links

* View: Open app/views/welcome/index.html.erb

		<%if user_signed_in? %>
			<h1> Bienvenido <%= current_user.email %></h1>
		<%else%>
			<h1>¡ Bienvenido al blog !</h1>
		<%end%>
		<a class="center-xs"><img src="http://1.bp.blogspot.com/-Fz7Sy-0x2u8/U6oZ8KHwPXI/AAAAAAAAAHU/eViNfw0-92Y/s1600/New+Moon+Collage.png"/></a>

* View: app/views/articles/index.html.erb

		<%= link_to "Crear nuevo articulo", new_article_url, class:"btn be-red white center-btn top-space" %>
		<%= link_to article.title, article %>  

* View: app/views/articles/new.html.erb


      <%= form_for(@article) do |f| %>
        ...
      <% end %>

      <%= f.submit "Publicar", class:"btn be-red white" %>

* View: app/views/articles/show.html.erb

		     <div class="center-article-info", style="background-image: url("fondo.jpg");">
			<h1><%= @article.title %></h1>
			<%if !@article.user.nil? %>
				<p>
					Autor: <%= @article.user.email %>
				</p>
			<%else%>
				<p>
					Autor anónimo.
				</p>
			<%end%>
			<p>
				Visitas: <%= @article.visits_count %>
			</p>
			<p>
				Visibilidad: <%= @article.visibility %>
			</p>
			<p>
				Fecha y hora de creación: <%= @article.created_at %>
			</p>
			<p>
				Descripción: <%= @article.body %>
			</p>
			<div class="field">
				<%= image_tag @article.image.url(:medium) %>
			</div>
			<br>
			<br>
			<% if !@article.user.nil? and @article.user == current_user %>
			<div class="actions">
				<strong><%= link_to "Editar", edit_article_path(@article), class:"btn be-red white" %></strong>
				<strong><%= link_to "Eliminar", @article, method: :delete, class:"btn white", style:"background-color: #E74C3C; " %></strong>
			</div>
			<%end%>
			<br>
			<br>
		</div>


# 13. Updating Articles     

* Route:     

      PUT    /articles/:id(.:format)                      articles#update

* Controller: edit action to the ArticlesController ->  app/controllers/articles_controller.rb
	
      before_action :set_article, except: [:new, :create, :index]
      def edit
      end
      
      private
      def article_params
      	params.require(:article).permit(:title, :body, :visibility, :image)
      end

* View: new page: app/views/articles/edit.html.erb

      <h1>Edit article</h1>

      <%= form_for(@article) do |f| %>

        <% if @article.errors.any? %>
          <div id="error_explanation">
            <h2>
              <%= pluralize(@article.errors.count, "error") %> prohibited
              this article from being saved:
            </h2>
            <ul>
              <% @article.errors.full_messages.each do |msg| %>
                <li><%= msg %></li>
              <% end %>
            </ul>
          </div>
        <% end %>

        <p>
          <%= f.label :title %><br>
          <%= f.text_field :title %>
        </p>

        <p>
          <%= f.label :text %><br>
          <%= f.text_area :text %>
        </p>

        <p>
          <%= f.submit %>
        </p>

      <% end %>

      <%= link_to 'Back', articles_path %>  

* Controller: update action in app/controllers/articles_controller.rb

	      def update
			#UPDATE
			@article.update_attributes({title: "Nuevo título"})
			@article = Article.find(params[:id]) ya está en el callback set_article
			if @article.update(article_params)
				redirect_to @article
			else
				render :edit
			end
	      end

	     
* Fix: 
	
      before_action :set_article, except: [:new, :create, :index]
      def update
		if @article.update(article_params)
			redirect_to @article
		else
			render :edit
		end
      end
      
      private
      def article_params
      	params.require(:article).permit(:title, :body, :visibility, :image)
      end

* View: add link 'edit' in app/views/articles/show.html.erb

	      ...
		<% if !@article.user.nil? and @article.user == current_user %>
		<div class="actions">
			<strong><%= link_to "Editar", edit_article_path(@article), class:"btn be-red white" %></strong>
			<strong><%= link_to "Eliminar", @article, method: :delete, class:"btn white", style:"background-color: #E74C3C; " %></strong>
		</div>
		<%end%>
		...

# 14. delete an Article

Route:

      DELETE /articles/:id(.:format)                      articles#destroy  

Controller: app/controllers/articles_controller.rb

        def destroy
		#DELETE FROM articles
		@article = Article.find(params[:id]) ya está en el callback set_article
		@article.destroy # Eliminar objeto de la base de datos
		redirect_to articles_path
	end             
	
Fix: 
	
	before_action :set_article, except: [:new, :create, :index]
	def destroy
		#DELETE FROM articles
		@article = Article.find(params[:id]) ya está en el callback set_article
		@article.destroy # Eliminar objeto de la base de datos
		redirect_to articles_path
	end 
	private
	def article_params
		params.require(:article).permit(:title, :body, :visibility, :image)
	end

View: add 'delete' link to app/views/articles/show.html.erb

      		...
		<% if !@article.user.nil? and @article.user == current_user %>
		<div class="actions">
			<strong><%= link_to "Editar", edit_article_path(@article), class:"btn be-red white" %></strong>
			<strong><%= link_to "Eliminar", @article, method: :delete, class:"btn white", style:"background-color: #E74C3C; " %></strong>
		</div>
		<%end%>
		...

## DEPLOYMENT ON DCA FOR TESTING

# 1. Deploy the Article Web App on Linux Centos 7.x (test)

## Install ruby and rails

* references:

      https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-ruby-on-rails-application-on-centos-7


* Connect remote server: (jossava is a sudo user)

      local$ ssh jossava@10.131.137.244
      Password: ********

      jossava@mydomain$

* verify and install rvm, ruby, rails, postgres and nginx

* install rvm (https://rvm.io/rvm/install)

        user1@mydomain$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

        user1@mydomain$ \curl -sSL https://get.rvm.io | bash

* reopen terminal app:

        jossava@mydomain$ exit

        local$ ssh jossava@10.131.137.244
        Password: ********

* install ruby 2.4.1

        jossava@mydomain$ rvm list known
        jossava@mydomain$ rvm install 2.4.1

* install rails

        jossava@mydomain$ gem install rails

## install postgres:

        jossava@mydomain$ sudo yum install -y postgresql-server postgresql-contrib postgresql-devel
        Password: ********

        jossava@mydomain$ sudo postgresql-setup initdb

        jossava@mydomain$ sudo vi /var/lib/pgsql/data/pg_hba.conf

        original:

        host    all             all             127.0.0.1/32            ident
        host    all             all             ::1/128                 ident

        updated:

        host    all             all             127.0.0.1/32            md5
        host    all             all             ::1/128                 md5

* run postgres:

        jossava@mydomain$ sudo systemctl start postgresql
        jossava@mydomain$ sudo systemctl enable postgresql

* Create Database User:

        user1@mydomain$ sudo su - postgres

        user1@test$ createuser -s pguser

        user1@test$ psql

        postgres=# \password pguser
        Enter new password: changeme

        postgres=# \q

        user1@test$ exit

## Setup RAILS_ENV and PORT (3000 for dev, 4000 for testing or 5000 for production)

        user1@test$ export RAILS_ENV=test
        user1@test$ export PORT=4000

## open PORT on firewalld service:

        user1@test$ sudo firewall-cmd --zone=public --add-port=4000/tcp --permanent
        user1@test$ sudo firewall-cmd --reload

## clone de git repo, install and run:

        jossava@mydomain$ mkdir apps
        jossava@mydomain$ cd apps
        jossava@mydomain$ git clone https://github.com/st0263eafit/rubyArticulosEM.git
        jossava@mydomain$ cd topicosTelematicaProyectoNivelacion
        jossava@mydomain$ bundle install
        jossava@mydomain$ rake db:drop db:create db:migrate
        jossava@mydomain$ export RAILS_ENV=test
        jossava@mydomain$ export PORT=4000
        jossava@mydomain$ rails server

# SETUP Centos 7.1 in production With Apache Web Server and Passenger.

* Install Apache Web Server

        jossava@mydomain$ sudo yum install httpd
        jossava@mydomain$ sudo systemctl enable httpd
        jossava@mydomain$ sudo systemctl start httpd

        test in a browser: http://10.131.137.244

* Install YARN (https://yarnpkg.com/en/docs/install) (for rake assets:precompile):  

* Install module Passenger for Rails in HTTPD (https://www.phusionpassenger.com/library/install/apache/install/oss/el7/):

        jossava@mydomain$ gem install passenger

        jossava@mydomain$ passenger-install-apache2-module

when finish the install module, add to /etc/http/conf/httpd.conf:

        LoadModule passenger_module /home/user1/.rvm/gems/ruby-2.4.1/gems/passenger-5.1.6/buildout/apache2/mod_passenger.so
        <IfModule mod_passenger.c>
          PassengerRoot /home/user1/.rvm/gems/ruby-2.4.1/gems/passenger-5.1.6
          PassengerDefaultRuby /home/user1/.rvm/gems/ruby-2.4.1/wrappers/ruby
        </IfModule>

* Configure the ruby rails app to use passenger (https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/apache/oss/el7/deploy_app.html):

* summary:

        - clone the repo to /var/www/myapp/topicosTelematicaProyectoNivelacion

        jossava@mydomain$ cd /var/www/myapp/topicosTelematicaProyectoNivelacion

        jossava@mydomain$ bundle install --deployment --without development test

        - Configure database.yml and secrets.yml:

        jossava@mydomain$ bundle exec rake secret
        jossava@mydomain$ vim config/secrets.yml

        production:
          secret_key_base: the value that you copied from 'rake secret'

        jossava@mydomain$ bundle exec rake assets:precompile db:migrate RAILS_ENV=production

* add pictoparticles.conf to /etc/httpd/conf.d/pictoparticles.conf:

       <VirtualHost *:80>
	    ServerName 10.131.137.244

	    # Tell Apache and Passenger where your app's 'public' directory is                                                                                
	    DocumentRoot /var/www/pictoparticles/code/proyecto1/public

	    PassengerRuby /home/jossava/.rvm/gems/ruby-2.4.1/wrappers/ruby

	    # Relax Apache security settings                                                                                                                  
	    <Directory /var/www/pictoparticles/code/proyecto1/public>
	      Allow from all
	      Options -MultiViews
	      # Uncomment this if you're on Apache >= 2.4:                                                                                                    
	      #Require all granted                                                                                                                            
	    </Directory>
      </VirtualHost>

* restart httpd

        user1@mydomain$ sudo systemctl restart httpd

        test: http://10.131.137.244

# SETUP Centos 7.1 in production With NGINX with inverse proxy

* Install nginx

        jossava@mydomain$ sudo yum install nginx
        jossava@mydomain$ sudo systemctl enable nginx
        jossava@mydomain$ sudo systemctl start nginx

        test in a browser: http://10.131.137.236

* Rails app is running on 3000 port

        jossava@mydomain$ cd proyecto1
        jossava@mydomain$ export RAILS_ENV=test
        jossava@mydomain$ export PORT=3000
        jossava@mydomain$ rails server
        => Booting Puma
        => Rails 5.1.2 application starting in test on http://0.0.0.0:3000
        => Run `rails server -h` for more startup options
        Puma starting in single mode...
        * Version 3.9.1 (ruby 2.4.1-p111), codename: Private Caller
        * Min threads: 5, max threads: 5
        * Environment: test
        * Listening on tcp://0.0.0.0:3000
        Use Ctrl-C to stop

* Warning: this app must as a service on Centos.

* Configure /etc/nginx/nginx.conf for Inverse Proxy

      App from browser: http://10.131.137.244/pictoparticles

      // /etc/nginx/nginx.conf

      location /pictoparticles/ {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header HOST $http_host;
        proxy_set_header X-NginX-Proxy true;
        proxy_pass http://127.0.0.1:3000;
        proxy_redirect off;
      }

* MODIFY THE APPLICATION IN ORDER TO CONFIGURE THE NEW URI ('/rubyArticulos'):

      // modify config/routes.rb
      # scope '/' -> run http://server:3000 (native) or http://server (inverse proxy or passenger)
      # scope '/prefix_url' -> run http://server:3000/prefix_url or http://server/prefix_url (inverse proxy or passenger).
      # ej: http://10.131.137.244//pictoparticles
      Rails.application.routes.draw do
      	scope '/pictoparticles' do
	  resources :articles
	  devise_for :users
	  root 'welcome#index'
        end
      end  
      
* Show new routes and controllers:

      jossava@mydomain$ rails routes

            Prefix Verb          URI Pattern                                  	Controller#Action
                articles GET    /pictoparticles/articles(.:format)                          articles#index
                         POST   /pictoparticles/articles(.:format)                          articles#create
             new_article GET    /pictoparticles/articles/new(.:format)                      articles#new
            edit_article GET    /pictoparticles/articles/:id/edit(.:format)                 articles#edit
                 article GET    /pictoparticles/articles/:id(.:format)                      articles#show
                         PATCH  /pictoparticles/articles/:id(.:format)                      articles#update
                         PUT    /pictoparticles/articles/:id(.:format)                      articles#update
                         DELETE /pictoparticles/articles/:id(.:format)                      articles#destroy
        new_user_session GET    /pictoparticles/users/sign_in(.:format)                     devise/sessions#new
            user_session POST   /pictoparticles/users/sign_in(.:format)                     devise/sessions#create
    	destroy_user_session DELETE /pictoparticles/users/sign_out(.:format)                devise/sessions#destroy
       new_user_password GET    /pictoparticles/users/password/new(.:format)                devise/passwords#new
      edit_user_password GET    /pictoparticles/users/password/edit(.:format)               devise/passwords#edit
           user_password PATCH  /pictoparticles/users/password(.:format)                    devise/passwords#update
                         PUT    /pictoparticles/users/password(.:format)                    devise/passwords#update
                         POST   /pictoparticles/users/password(.:format)                    devise/passwords#create
			 ...
