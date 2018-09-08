defmodule Breakbench.Auth.Config do
  @moduledoc false

  def auth_config do
    Application.get_env(:breakbench, Breakbench.Auth)
  end

  def remember_key do
    Keyword.get(auth_config(), :remember_key, "_remember_key")
  end

  def max_age do
    Keyword.get(auth_config(), :max_age, 604800)
  end

  def token_salt do
    Keyword.get(auth_config(), :token_salt)
      || raise "token_salt is required."
  end
end
