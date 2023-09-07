defmodule Tash.Api.Login do
  @user_agent "Ta$h/1.0"
  @api_key "Hello-Orlando!"
  @device_id "TFYKXYI4IEQC2MQR"

  def login(username, password) do
    encoded_password = encode_password(password)

    case HTTPoison.post(
           "https://orlando.teller.engineering/signin",
           Jason.encode!(%{"password" => encoded_password, "username" => username}),
           [
             {"User-Agent", @user_agent},
             {"api-key", @api_key},
             {"device-id", @device_id},
             {"accept", "application/json"},
             {"Content-type", "application/json"}
           ]
         ) do
      {:ok, %HTTPoison.Response{status_code: 200} = res} ->
        headers = Map.new(res.headers)
        token = Map.get(headers, "r-token")
        {token, Jason.decode!(res.body)}

      _ ->
        {:error, :bad_password}
    end
  end

  def encode_password(password) do
    case HTTPoison.get("https://orlando.teller.engineering/config", [
           {"User-Agent", @user_agent},
           {"api-key", @api_key},
           {"device-id", @device_id},
           {"accept", "application/json"}
         ]) do
      {:ok, %HTTPoison.Response{status_code: 200} = res} ->
        decoded_config = Jason.decode!(res.body)
        key = get_in(decoded_config, ["utils", "arg_b"])
        EncoderDecoder.transform(key, password)

      _ ->
        {:error, :bad_config}
    end
  end
end
