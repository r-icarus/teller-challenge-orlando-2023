defmodule EncoderDecoder do
  def transform(key, payload) do
    bytes = :erlang.binary_to_list(payload)
    key = <<key_prefix()::binary, key::binary>>

    String.Chars.to_string(
      Enum.map(
        Stream.zip(
          Stream.cycle(:erlang.binary_to_list(key)),
          bytes
        ),
        fn {a, b} -> :erlang.bxor(:erlang.band(a, 171), b) end
      )
    )
  end

  defp key_prefix() do
    "Orlando:"
  end
end
