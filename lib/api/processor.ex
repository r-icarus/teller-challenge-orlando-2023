defmodule Tash.Api.Processor do
  def execute() do
    case Tash.Api.Login.login("purple_missy", "reunion") do
      {:error, _} = err ->
        err

      {token, devices} ->
        case Tash.Api.Verification.verify(token, devices) do
          {:error, _} = err ->
            err

          {r_token, s_token, balance_data} ->
            IO.inspect(balance_data)
            case Tash.Api.Payees.payees(r_token, s_token) do
              {:error, _} = err ->
                err

              {r_token, s_token, challenge, payees} ->
                IO.inspect(payees)

                Tash.Api.Payment.pay(
                  "candace.mills@example.com",
                  80000,
                  "Pay Candace",
                  r_token,
                  s_token,
                  challenge
                )
            end
        end
    end
  end

  def execute_create_payee() do
    case Tash.Api.Login.login("purple_missy", "reunion") do
      {:error, _} = err ->
        err

      {token, devices} ->
        case Tash.Api.Verification.verify(token, devices) do
          {:error, _} = err ->
            err

          {r_token, s_token, _balance_data} ->
            case Tash.Api.Payees.payees(r_token, s_token) do
              {:error, _} = err ->
                err

              {r_token, s_token, _challenge, _payees} ->
                case Tash.Api.Payees.create(r_token, s_token, "arnaldo1908@example.net") do
                  {:error, _} = err ->
                    err

                  res ->
                    res
                end
            end
        end
    end
  end
end
