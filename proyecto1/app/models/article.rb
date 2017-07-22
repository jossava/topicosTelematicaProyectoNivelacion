class Article < ApplicationRecord
	# La tabla => articles
	# Campos => article.title() => 'El titulo del articulo'
	# Escribir metodos
	validates :title, presence: true, uniqueness: true
	validates :body, presence: true, length: { minimum: 20}
	#validates :username, format: { with: /regex/}
end
