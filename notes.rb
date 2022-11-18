# Validations

A movie must have a unique title and an overview.
A list must have a unique name.
A bookmark must be linked to a movie and a list, and the [movie, list] pairings should be unique.
The comment of a bookmark cannot be shorter than 6 characters.

# Associations

A list has many bookmarks
A list has many movies through bookmarks
A movie has many bookmarks
A bookmark belongs to a movie
A bookmark belongs to a list
You can’t delete a movie if it is referenced in at least one bookmark.
When you delete a list, you should delete all associated bookmarks (but not the movies as they can be referenced in other lists).


A movie has a title (e.g. "Wonder Woman 1984"), an overview ("Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s!"), a poster url and a rating (6.9).
A list has a name (e.g. "Drama", "Comedy", "Classic", "To rewatch", … )
A bookmark adds a movie to a list (e.g. Wonder Woman has been added to the “Girl Power” watch list). So each bookmark references a movie and a list, with a comment. The comment field is for the user to add a little note on the bookmark (e.g. Alan Turing recommended this movie).

rails generate model movie title:string overview:text poster_url:string rating:float
rails generate model list name:string
rails generate model bookmark comment:text


bookmark
t.references :movie, foreign_key: true
t.references :list, foreign_key: true

class List < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :movies, through: :bookmarks
  validates :name, uniqueness: { case_sensitive: false }
end

class Movie < ApplicationRecord
  has_many :bookmarks
  validates :overview, presence: true
  validates :title, uniqueness: { case_sensitive: false }
  #has_many :movies, through: :bookmarks
end

class Bookmark < ApplicationRecord
  belongs_to :movie
  belongs_to :list
  validates_associated :movie, :list
  validates :comment, length: { minimum: 6 }
  validates_uniqueness_of :movie_id, scope: [:list_id]
  #has_many :movies, through: :bookmarks
end

rails generate controller movies
rails generate controller lists
rails generate controller bookmarks

rails db:rollback
rails destroy model movie


GET "lists" #lists; lists#index

GET "lists/42" #list; lists#show

GET "lists/new"  # new_list; lists#new
POST "lists" # lists#create

GET "lists/42/bookmarks/new" #new_list_bookmark; bookmarks#new
POST "lists/42/bookmarks" # bookmarks#create

DELETE "bookmarks/25" # bookmarks#delete


<%= bookmarks = [] %>
<%= movies = [] %>
<%= @movies = Movie.all %>
<% @bookmarks.each do |bookmark| %>
  <% if bookmark.list_id == @list.id %>
    <%= bookmarks << bookmark %>
  <% end %>
  <% @movies.each do |movie|%>
    <%if movie.id == bookmark.movie_id%>
      <%=movies << movie%>
    <% end %>
  <% end %>
<% end %>
<ul class="list-group">
  <% movies.each do |movie| %>
    <li class="list-group-item">
    <%= movie.title %>
    <%= movie.rating %>
    <%= movie.overview %>
    </li>
  <% end %>
</ul>


<%= @movies = Movie.all %>
<% @movies.each do |movie| %>
  <h3><%= movie.title  %></h3>
  <p><%= movie.rating  %></p>
  <p><%= movie.overview %></p>
  <p><%= link to "add", _path %></p>
<% end %>

<%= simple_form_for [@list, @bookmark] do |f| %>
  <%= f.input :comment %>
  <%= f.input :comment %>
  <%= f.submit "Submit comment", class: "btn btn-primary" %>
<% end %>
<br>
<br>
<p><%= link_to "Back to restaurant", list_path(@list) %></p>

<p><%= button_to "Back to list", restaurants_path, method: :get  %></p>
