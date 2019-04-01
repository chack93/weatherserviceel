defmodule WSE.Model.Error do
  defmodule Internal do
    defexception plug_status: 500, message: "Internal server error", conn: nil, router: nil
  end

  defimpl Plug.Exception, for: WSE.Model.Error.Internal do
    def status(_exception), do: 500
  end
end
