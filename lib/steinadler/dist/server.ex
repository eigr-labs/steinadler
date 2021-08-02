defmodule Steinadler.Dist.Server do
  def listen(name) do
    # Here we figure out what port we want to listen on.

    port = Steinadler.Dist.Epmdless.dist_port(name)

    # Set both "min" and "max" variables, to force the port number to
    # this one.
    :ok = :application.set_env(:kernel, :inet_dist_listen_min, port)
    :ok = :application.set_env(:kernel, :inet_dist_listen_max, port)

    # Finally run the real function!
    :inet_tcp_dist.listen(name)
  end

  def select(node) do
    :inet_tcp_dist.select(node)
  end

  def accept(listen) do
    :inet_tcp_dist.accept(listen)
  end

  def accept_connection(accept_pid, socket, my_node, allowed, setup_time) do
    :inet_tcp_dist.accept_connection(accept_pid, socket, my_node, allowed, setup_time)
  end

  def setup(node, type, my_node, long_or_short_names, setup_time) do
    :inet_tcp_dist.setup(node, type, my_node, long_or_short_names, setup_time)
  end

  def close(listen) do
    :inet_tcp_dist.close(listen)
  end

  def childspecs do
    :inet_tcp_dist.childspecs()
  end
end
