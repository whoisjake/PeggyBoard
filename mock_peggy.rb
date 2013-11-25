require 'rubygems'
require 'securerandom'
require 'json'
require 'sinatra'

BOARD = []
LEASE = {}
ROWS = 12
COLUMNS = 80

def init_board
  BOARD.clear
  ROWS.times do
    row = " " * COLUMNS
    BOARD << row
  end
end

init_board

get '/' do
  erb :index
end

get '/litebrite/peggy/get_lease/:length' do |length|
  LEASE[:lease_code] = SecureRandom.hex
  LEASE[:lease_expiry] = Time.now + length.to_i
  content_type 'application/json'
  LEASE.merge({:result => "success"}).to_json
end

get '/litebrite/peggy/write/:lease/:y/:x/:content' do |lease,y,x,content|
  r = BOARD[y.to_i]
  s = r[x.to_i,content.length]
  r.gsub!(s,content)
  content_type 'application/json'
  {:result => "success"}.to_json
end

get '/litebrite/peggy/clear/:lease' do |lease|
  init_board
  content_type 'application/json'
  {:result => "success"}.to_json
end

__END__

@@ layout
<html>
  <head>
    <title>Peggy</title>
    <meta http-equiv="refresh" content="5">
  </head>
  <%= yield %>
</body>
</html>

@@ index
<table>
  <tbody>
    <% ROWS.times do |r| %>
    <tr>
      <%= BOARD[r].gsub(/(.)/,'<td>\1</td>') %>
    </tr>
    <% end %>
  </tbody>  
</table>