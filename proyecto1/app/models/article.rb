class Article < ApplicationRecord
	# La tabla => articles
	# Campos => article.title() => 'El titulo del articulo'
	# Escribir metodos
	belongs_to :user
	has_many :comments
	validates :title, presence: true, uniqueness: true
	validates :body, presence: true, length: { minimum: 20}
	before_create :set_visits_count

	def update_visits_count
		#self.visits_count = 0 if self.visits_count.nil?
		self.update(visits_count: self.visits_count + 1)
	end

	private

	def set_visits_count
		self.visits_count = 0
	end
	#validates :username, format: { with: /regex/}
end
