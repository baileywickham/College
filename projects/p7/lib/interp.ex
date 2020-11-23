defmodule Interp do
  @doc """
  Evaluates an expression represented as a ExprC and returns the value that results
  """
  def interp(e, env) do
    case e do
      var when is_integer(var) or is_bitstring(var) ->
        var

      id when is_atom(id) ->
        lookup(id, env)

      %IfC{f: f, t: t, e: e} ->
        if check_bool(interp(f, env)), do: interp(t, env), else: interp(e, env)

      %LamC{args: args, body: body} ->
        %ClosV{args: args, body: body, env: env}

      %AppC{f: f, args: args} ->
        apply_func(interp(f, env), for(x <- args, do: interp(x, env)))
    end
  end

  @doc """
  Applies a function (either a primitive or a closure) and returns the value of the result or an error
  """
  def apply_func(f, args) do
    case f do
      %PrimV{o: o, arity: n} ->
        if length(args) == n,
          do: o.(args),
          else: raise(DxuqError, message: "Primitive has wrong airity")

      %ClosV{args: ids, body: body, env: env} ->
        interp(body, make_env(ids, args, env))

      _ ->
        raise DxuqError, message: "Unable to apply function: #{inspect(f)}"
    end
  end

  @doc """
  Searches through a list of bindings for a given id, if the id is found the value in the binging is
  returned, otherwise an unbound identifier error is raised
  """
  def lookup(id, env) do
    if Map.has_key?(env, id),
      do: env[id],
      else: raise(DxuqError, message: "Unbound variable: #{inspect(id)}")
  end

  @doc """
  Given a list of argument names and values, matches them into a list of bindings or raises an error
  if the arity does not match. Prepends this to an existing environment
  """
  def make_env(ids, args, env) do
    Map.merge(env, Map.new(List.zip([ids, args])))
  end

  @doc """
  Wraps a value and ensures it is a bool, throwing an error otherwise
  """
  def check_bool(v) do
    unless is_boolean(v) do
      raise DxuqError, message: "Type mismatch: #{Serialize.serialize(v)} is not a bool"
    end

    v
  end
end
