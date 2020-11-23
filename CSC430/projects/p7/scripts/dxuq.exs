IO.read(:stdio, :all)
|> TopInterp.top_interp
|> IO.puts