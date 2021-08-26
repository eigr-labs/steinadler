defmodule Steinadler.Dist.Protocol.Util do
  @moduledoc false

  def dist_port(name) when is_binary(name) do
    base_port = Application.get_env(:steinadler, :grpc_port, 4_000)

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
