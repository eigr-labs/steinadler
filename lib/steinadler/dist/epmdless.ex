defmodule Steinadler.Dist.Epmdless do
  def dist_port(name) when is_atom(name) do
    dist_port(Atom.to_string(name))
  end

  def dist_port(name) when is_list(name) do
    dist_port(List.to_string(name))
  end

  def dist_port(name) when is_binary(name) do
    # Figure out the base port.  If not specified using the
    # inet_dist_base_port kernel environment variable, default to
    # 4370, one above the epmd port.
    base_port = :application.get_env(:kernel, :inet_dist_base_port, 4370)

    # Now, figure out our "offset" on top of the base port.  The
    # offset is the integer just to the left of the @ sign in our node
    # name.  If there is no such number, the offset is 0.
    #
    # Also handle the case when no hostname was specified.
    node_name = Regex.replace(~r/@.*$/, name, "")

    offset =
      case Regex.run(~r/[0-9]+$/, node_name) do
        nil ->
          0

        [offset_as_string] ->
          String.to_integer(offset_as_string)
      end

    base_port + offset
  end
end
