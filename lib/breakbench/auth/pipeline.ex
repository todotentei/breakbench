defmodule Breakbench.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :breakbench,
    error_handler: Breakbench.Auth.ErrorHandler,
    module: Breakbench.Auth.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
