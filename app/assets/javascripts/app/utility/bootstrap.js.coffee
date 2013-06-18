define () ->

  bootstrap = {}

  () -> bootstrap


#<% content_for :backbone_bootstrap do %>
#div = $('<div></div>')
#div.html($('#<%= "bootstrap-#{key}" %>').text());
#data = JSON.parse(div.text());
#window.Vocat.Bootstrap.Collections.<%= key %> = data.<%= key %>;
#<% end %>