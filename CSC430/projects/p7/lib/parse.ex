defmodule Parse do
  @doc """
  Checks if the argument is a valid id (symbol and not builtin name)
  """
  defguard is_id(s) when is_atom(s) and s not in ~w[if fn let in]a

  @doc """
  Converts an s-expression representing the body of a function to an ExprC representation
  All of the casts in this function should be ensured to succeed by the match patterns
  """
  def parse(sexp) do
    case sexp do
      var when is_integer(var) or is_bitstring(var) -> var
      id when is_id(id) -> id
      [:if, f, t, e] -> %IfC{f: parse(f), t: parse(t), e: parse(e)}
      [:fn, args, body] when is_list(args) -> %LamC{args: validate_args(args), body: parse(body)}
      [:let | sexp] -> desugar_let(sexp)
      [f | args] -> %AppC{f: parse(f), args: for(x <- args, do: parse(x))}
      _ -> raise DxuqError, message: "Unable to parse #{inspect(sexp)}"
    end
  end

  @doc """
  Given an s-expression representing the let clause after the word let, and possibly the
  ids and args parsed so far, returns a de-sugaring of the let clause
  """
  def desugar_let(sexp, ids \\ [], vals \\ []) do
    case sexp do
      [:in, body] ->
        %AppC{
          f: %LamC{
            args: validate_args(ids),
            body: parse(body)
          },
          args: vals
        }

      [[id, :=, val] | rest] when is_id(id) ->
        desugar_let(rest, ids ++ [id], vals ++ [parse(val)])

      _ ->
        raise DxuqError, message: "Unable to parse let clause #{inspect(sexp)}"
    end
  end

  @doc """
  Given a list ensures it contains unique valid ids, or raises an error
  """
  def validate_args(args) do
    unless args_are_valid(args) do
      raise DxuqError, message: "Invalid arguments in #{inspect(args)}"
    end

    args
  end

  @doc """
  Given a list returns true if it contains unique valid ids
  """
  def args_are_valid(args) do
    case args do
      [] -> true
      [arg | rest] when is_id(arg) -> arg not in rest and validate_args(rest)
      _ -> false
    end
  end
end
