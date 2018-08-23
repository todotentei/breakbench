defmodule Breakbench.StripeMockServer do
  @moduledoc false


  def request(_, "charges" <> _, %{customer: "ok_customer"}) do
    {:ok, %{
      id: "test_customer",
      object: "charge"
    }}
  end

  def request(_, "charges" <> _, %{customer: "error_customer"}) do
    {:error, %{
      code: "parameter_missing",
      doc_url: "https://stripe.com/docs/error-codes/parameter-missing",
      message: "Must provide source or customer.",
      type: "invalid_request_error"
    }}
  end
end
