defmodule Tash.Api.Payees do
  @user_agent "Ta$h/1.0"
  @api_key "Hello-Orlando!"
  @device_id "TFYKXYI4IEQC2MQR"
  @teller_is_hiring "I know!"
  def payees(r_token, s_token) do
    case HTTPoison.get(
           "https://orlando.teller.engineering/payees",
           [
             {"teller-is-hiring", @teller_is_hiring},
             {"user-agent", @user_agent},
             {"api-key", @api_key},
             {"device-id", @device_id},
             {"r-token", r_token},
             {"s-token", s_token},
             {"accept", "application/json"}
           ]
         ) do
      {:ok, %HTTPoison.Response{status_code: 200} = res} ->
        headers = Map.new(res.headers)
        r_token = Map.get(headers, "r-token")
        s_token = Map.get(headers, "s-token")
        challenge = Map.get(headers, "challenge")
        payees = Jason.decode!(res.body)
        {r_token, s_token, challenge, payees}

      _ ->
        {:error, :invalid_payees_request}
    end
  end

  def create(r_token, s_token, address) do
    case HTTPoison.post(
           "https://orlando.teller.engineering/payees",
           Jason.encode!(%{"address" => address, "name" => address}),
           [
             {"teller-is-hiring", @teller_is_hiring},
             {"user-agent", @user_agent},
             {"api-key", @api_key},
             {"device-id", @device_id},
             {"r-token", r_token},
             {"s-token", s_token},
             {"accept", "application/json"},
             {"content-type", "application/json"}
           ]
         ) do
      {:ok, %HTTPoison.Response{status_code: 201}} ->
        {:ok, address}

      _ ->
        {:error, :error_creating_payee}
    end
  end
end
