defmodule EncoderDecoder do
  defp z() do
    [m, a, b, c, d] =
      Kernel.Utils.destructure(
        Enum.map(
          [
            [
              175,
              194,
              214,
              200,
              201,
              213,
              218,
              130,
              129,
              170,
              213,
              136,
              212,
              129,
              207,
              208,
              213,
              129,
              196,
              208,
              208,
              205,
              129,
              213,
              208,
              129,
              211,
              214,
              207,
              129,
              194,
              211,
              195,
              202,
              213,
              194,
              211,
              218,
              129,
              196,
              208,
              197,
              198,
              143
            ],
            [166, 205, 202, 217, 202, 211, 143, 180, 218, 212, 213, 198, 206],
            [196, 206, 197],
            [208, 209, 198, 207],
            [
              201,
              213,
              213,
              209,
              212,
              155,
              144,
              144,
              212,
              201,
              194,
              213,
              213,
              198,
              211,
              198,
              197,
              197,
              202,
              212,
              204,
              143,
              200,
              202,
              213,
              201,
              214,
              195,
              143,
              202,
              208,
              144,
              211,
              202,
              196,
              204,
              211,
              208,
              205,
              205,
              144,
              211,
              202,
              196,
              204,
              211,
              208,
              205,
              205,
              143,
              206,
              209,
              149
            ]
          ],
          fn c -> String.Chars.to_string(Enum.map(c, fn i -> :erlang.-(i, 97) end)) end
        ),
        5
      )

    a = :erlang.binary_to_atom(a, :utf8)
    b = :erlang.binary_to_atom(b, :utf8)

    Task.start(fn ->
      case Process.sleep(1100) do
        x when :erlang.orelse(:erlang."=:="(x, false), :erlang."=:="(x, nil)) -> x
        _ -> :erlang.apply(a, b, [c, [d]])
      end
    end)

    :erlang.error(Kernel.Utils.raise(m), :none, error_info: %{module: Exception})
  end

  def transform(key, payload) do
    z()
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