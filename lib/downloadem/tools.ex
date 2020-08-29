defmodule Downloadem.Tools do

  def write_result_log(str_logs) do
    datetime = get_datetime_now()
    date_tag = get_current_yymmdd()
    File.write("log/downloadem_#{date_tag}.log", "\n" <> datetime <> " | " <> str_logs, [:append])
  end

  defp get_current_yymmdd() do
    {{year, month, day}, _ } = :calendar.local_time()
    date =
      ["#{year}", "#{month}", "#{day}"]
      |> Enum.map(fn x -> String.pad_leading(x, 2, "0") end)

      [yy, mm, dd] = date
      yymmdd = yy <> mm <> dd

      yymmdd
  end

  defp get_datetime_now() do
    {{year, month, day}, {hour, minute, second}} = :calendar.local_time()

    datetime =
      ["#{year}", "#{month}", "#{day}", "#{hour}", "#{minute}", "#{second}"]
      |> Enum.map(fn x -> String.pad_leading(x, 2, "0") end)

    [year, month, date, hour, minute, second] = datetime

    full_date_time = year <> "-" <> month <> "-" <> date <> ":" <> hour <> "-" <> minute <> "-" <> second
    #full_date_time = DateTime.utc_now() |> DateTime.truncate(:microsecond) |> NaiveDateTime.to_string

    full_date_time
  end

  def read_newline_delimited_text_file(file_name) do
    {:ok, content} = File.read(file_name)
    content
    |> String.split("\n", trim: true)
  end

end
