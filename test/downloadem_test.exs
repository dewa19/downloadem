defmodule DownloademTest do
  use ExUnit.Case
  alias Downloadem.Tools, as: Tools
  alias Downloadem.Storage, as: Storage
  #doctest Downloadem

    describe "test_downloadem" do

      test "Execute main download function" do
        actual = Downloadem.execute_download()
        expected = :ok
        #assert ^expected = actual
        assert actual == expected
      end

      # run specific test
      #mix test test/downloadem_test.exs --only line:17 (by line number)
      #mix test test/downloadem_test.exs --only open_file (by tag name)
      @tag :open_file
      test "Open URL list file" do
        actual = Tools.read_newline_delimited_text_file("data/url_list.txt")
        expected = [
              "https://www.youtube.com/watch?v=7-qGKqveZaM",
              "https://www.youtube.com/watch?v=tPEE9ZwTmy0",
              "https://www.youtube.com/watch?v=XZsFbB3lV1A",
              "https://www.youtube.com/watch?v=hF83JAmBdjY"
            ]
        #assert ^expected = actual
        assert actual == expected
      end

      @tag :write_log_file
      test "Write to log file" do
          message = "download start"
          actual = Tools.write_result_log(message)
          expected = :ok
          assert actual == expected
      end

      @tag :run_downloader
      test "Execute youtube-dl" do
          url = "https://www.youtube.com/watch?v=7-qGKqveZaM"
          actual = Downloadem.run_downloader(url)
          expected = {"[youtube] 7-qGKqveZaM: Downloading webpage\n[youtube] 7-qGKqveZaM: Downloading video info webpage\n[download] Destination: downloaded/Shortest Video on Youtube EVER! 0 seconds nearly 1 (fastest)-7-qGKqveZaM.mp4\n[download] Download completed\n", 0}
          assert actual == expected
      end

      @tag :run_downloader_twice
      test "Execute youtube-dl again" do
          url = "https://www.youtube.com/watch?v=7-qGKqveZaM"
          actual = Downloadem.run_downloader(url)
          expected = {
              "[youtube] 7-qGKqveZaM: Downloading webpage\n[youtube] 7-qGKqveZaM: Downloading video info webpage\n[download] downloaded/Shortest Video on Youtube EVER! 0 seconds nearly 1 (fastest)-7-qGKqveZaM.mp4 has already been downloaded\n[download] Download completed\n",0}
          assert actual == expected
      end


      @tag :task_async
      test "Create download process" do
          Storage.start_agent_list()
          list_of_url = ["https://www.youtube.com/watch?v=7-qGKqveZaM"]
          list_of_task = Downloadem.do_concurrent_download(list_of_url)
          [%Task{owner: _, pid: mytask_pid, ref: _}] = list_of_task
          expected = Process.alive?(mytask_pid)
          assert expected == true
      end

  end
end
