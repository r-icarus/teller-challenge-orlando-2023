defmodule Tash.Api.Payment do
  @user_agent "Ta$h/1.0"
  @api_key "Hello-Orlando!"
  @device_id "TFYKXYI4IEQC2MQR"
  @teller_is_hiring "I know!"

  def pay(email, amount, note, r_token, s_token, challenge) do
    challenge_answer = solve_challenge(challenge)
    # This key is used to avoid making the same payment twice
    idempotency_key = UUID.uuid1()

    case HTTPoison.post(
           "https://orlando.teller.engineering/payments",
           Jason.encode!(%{
             "amount" => amount,
             "note" => note,
             "payee" => email,
             "idempotency_key" => idempotency_key
           }),
           [
             {"teller-is-hiring", @teller_is_hiring},
             {"user-agent", @user_agent},
             {"api-key", @api_key},
             {"device-id", @device_id},
             {"r-token", r_token},
             {"s-token", s_token},
             {"challenge", challenge},
             {"challenge-answer", challenge_answer},
             {"accept", "application/json"},
             {"content-type", "application/json"}
           ]
         ) do
      {:ok, %HTTPoison.Response{status_code: 200} = res} ->
        IO.inspect(res)
        body = Jason.decode!(res.body)
        {:ok, Map.get(body, "balance")}

      _ = res ->
        IO.inspect(res)
        {:error, :error_making_payment}
    end
  end

  def solve_challenge(challenge) do
    {result, 0} =
      System.cmd("/home/ricarus/projects/pinata/tash/encoder-linux-x86_64", [challenge])

    String.trim(result)
  end
end
