defmodule Tash.Api.Verification do
  @user_agent "Ta$h/1.0"
  @api_key "Hello-Orlando!"
  @device_id "TFYKXYI4IEQC2MQR"
  @verify_code "001337"
  @teller_is_hiring "I know!"

  def verify(token, devices) do
    # Should select the type SMS but it's always the first
    device = List.first(get_in(devices, ["data", "devices"]))
    device_id = device["id"]

    case HTTPoison.post(
           "https://orlando.teller.engineering/signin/mfa/request",
           Jason.encode!(%{"device_id" => device_id}),
           [
             {"teller-is-hiring", @teller_is_hiring},
             {"user-agent", @user_agent},
             {"api-key", @api_key},
             {"device-id", @device_id},
             {"r-token", token},
             {"accept", "application/json"},
             {"content-type", "application/json"}
           ]
         ) do
      {:ok, %HTTPoison.Response{status_code: 200} = device_response} ->
        headers = Map.new(device_response.headers)
        token = Map.get(headers, "r-token")

        case HTTPoison.post(
               "https://orlando.teller.engineering/signin/mfa/verify",
               Jason.encode!(%{"code" => @verify_code}),
               [
                 {"teller-is-hiring", @teller_is_hiring},
                 {"user-agent", @user_agent},
                 {"api-key", @api_key},
                 {"device-id", @device_id},
                 {"r-token", token},
                 {"accept", "application/json"},
                 {"content-type", "application/json"}
               ]
             ) do
          {:ok, %HTTPoison.Response{status_code: 200} = res} ->
            headers = Map.new(res.headers)
            r_token = Map.get(headers, "r-token")
            s_token = Map.get(headers, "s-token")
            balance_data = Jason.decode!(res.body)

            {r_token, s_token, balance_data}

          _ ->
            {:error, :bad_verification_code}
        end

      _ ->
        {:error, :bad_verification_select_device}
    end
  end
end
