defmodule WSE.Model.Error do
  defmodule(Internal,
    do: defexception(plug_status: 500, message: "Internal server error", conn: nil, router: nil)
  )

  defmodule(NotFound,
    do: defexception(plug_status: 404, message: "Not found", conn: nil, router: nil)
  )

  defmodule(BadRequest,
    do: defexception(plug_status: 400, message: "Bad request", conn: nil, router: nil)
  )

  defimpl Plug.Exception, for: WSE.Model.Error.Internal do
    def status(exception), do: exception.plug_status
  end

  defimpl Plug.Exception, for: WSE.Model.Error.NotFound do
    def status(exception), do: exception.plug_status
  end

  defimpl Plug.Exception, for: WSE.Model.Error.BadRequest do
    def status(exception), do: exception.plug_status
  end
end
