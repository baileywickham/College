defmodule IfC, do: defstruct(~w[f t e]a)
defmodule AppC, do: defstruct(~w[f args]a)
defmodule LamC, do: defstruct(~w[args body]a)

defmodule ClosV, do: defstruct(~w[args body env]a)
defmodule PrimV, do: defstruct(~w[o arity]a)

defmodule Str, do: defstruct(~w[str]a)
