defmodule Downloadem.Tools do

  # without "/" at the end
  @log_file_folder "log"

  # write info to log file
  def write_result_log(str_logs) do
    datetime = get_datetime_now()
    date_tag = get_current_yymmdd()
    File.write("#{@log_file_folder}/downloadem_#{date_tag}.log", "\n" <> datetime <> " | " <> str_logs, [:append])
  end

  # get current year, month, date in format YYYYMMDD
  defp get_current_yymmdd() do
    {{year, month, day}, _ } = :calendar.local_time()
    date =
      ["#{year}", "#{month}", "#{day}"]
      |> Enum.map(fn x -> String.pad_leading(x, 2, "0") end)

      [yy, mm, dd] = date
      yymmdd = yy <> mm <> dd

      yymmdd
  end

  # get current year, month, date, hour. minute, second in format YYYY-MM-DD:HH-MI-SS as a prefix to all info writen into log file
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

  # read file and put its content in list structure
  def read_newline_delimited_text_file(file_name) do
    {:ok, content} = File.read(file_name)
    content
    |> String.split("\n", trim: true)
  end

end
