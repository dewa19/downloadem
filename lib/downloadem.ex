defmodule Downloadem do
  alias Downloadem.Tools, as: Tools
  alias Downloadem.Storage, as: Storage

  @moduledoc """

  Author : dewa19
  Blog : http://backends.blogspot.com/

  Downloadem is concurrent Youtube video downloader.
  It utilizes 3rd party program called "youtube-dl" along with its 4 parameters, ie:
  1. --no-progress
  2. --format
  3. mp4
  4. -o

  Hence, the complete command :

  youtube-dl --no-progress --format mp4 -o "/download_path/%(title)s-%(id)s.%(ext)s"  "Youtube_video_URL", it gives instruction to "silently download the best quality of mp4 format video that available"

  eg:

  iex(11)> Downloadem.execute_download()
  Download BEGIN : [https://www.youtube.com/watch?v=up-WBD6vc4o]
  Download BEGIN : [https://www.youtube.com/watch?v=hXdfZTphZ9w]
  Download END : [https://www.youtube.com/watch?v=up-WBD6vc4o]
  Download END : [https://www.youtube.com/watch?v=hXdfZTphZ9w]
  :ok

  """

  @url_file_location "data/url_list.txt"
  @youtube_dl_download_folder "downloaded"
  @youtube_dl_executable_file "/home/sigit/Apps/youtube-dl/youtube-dl"
  @youtube_dl_options ["--no-progress", "--format", "mp4", "-o",  "#{@youtube_dl_download_folder}/%(title)s-%(id)s.%(ext)s"]

  @doc """

      Function : execute_download
      Main function of download process
      1. Start agent Storage
      2. Read URL list from text file
        a. Pass to function do_concurrent_download
        b. Pass to function listen_and_trap_exit_signal

      3. Stop agent Storage

  """
  def execute_download do
    Storage.start_agent_list()

    list_of_url = Tools.read_newline_delimited_text_file(@url_file_location)

    list_of_url
    |> do_concurrent_download
    |> listen_and_trap_exit_signal

    Storage.stop_agent_list()
  end

  defp listen_and_trap_exit_signal([]) do :ok end

  defp listen_and_trap_exit_signal(tasks) do
    parent_pid = self()

    receive do
      # when monitored process (a task) dies, a message is delivered to the monitoring process (parent) in the shape of {:DOWN, ref, :process, object, reason} eg: {:DOWN, #Reference<0.906660723.3006791681.40191>, :process, #PID<0.118.0>, :noproc}
      {:DOWN, monitor_reference, :process, task_pid, _reason} ->

          current_task = %Task{owner: parent_pid, pid: task_pid, ref: monitor_reference}

          urlpid_list = Storage.get_from_agent_list()
          url = get_url_from_urlpid_list(urlpid_list, task_pid)
          Tools.write_result_log("Download END : [#{url}]")
          IO.puts "Download END : [#{url}]"

          #remove this task from the list of tasks
          new_tasks_list = List.delete(tasks, current_task)
          listen_and_trap_exit_signal(new_tasks_list)

      #When task terminate, parent process received back its monitor_reference it triggered before when process created (by Task.async). Parent process implicitly call "Process.monitoring(task_PID)" so it can monitor the status of that task. Eg: monitor_reference = #Reference<0.906660723.3006791681.40191>

      other_msg ->
          {monitor_reference, {youtube_dl_message, 0}} = other_msg
          Tools.write_result_log("#{inspect(monitor_reference)}\n" <> youtube_dl_message)
          listen_and_trap_exit_signal(tasks)

    end

  end

  @doc """

      Function : do_concurrent_download
      For each URL in the list :
      1. Create a new process
      2. Call run_downloader function which actually execute download engine (youtube-dl & its parameters) to download the video specified by the URL

  """

  def do_concurrent_download(list_of_url) do
      list_of_task =
        list_of_url
        |> Enum.map(fn(url)->
            Task.async(fn ->
              url |> run_downloader()
            end)
          end)

          list_of_pid = Enum.map(list_of_task, fn task_structure -> task_structure.pid end)
          list_pid_url = Enum.zip(list_of_pid, list_of_url)
          Storage.put_to_agent_list(list_pid_url)

      list_of_task
      # |> Enum.map(&Task.await/1)
  end

  @doc """

      Function : run_downloader
      Execute download process
      - Call youtube-dl + parameters + URL

      Eg :
      /home/sigit/Apps/youtube-dl/youtube-dl --no-progress --format mp4 -o '/home/sigit/Elixir/real-project/downloadem/downloaded/%(title)s-%(id)s.%(ext)s' "https://www.youtube.com/watch?v=hF83JAmBdjY"

  """

  def run_downloader(url) do
    IO.puts("Download BEGIN : [#{url}]")
    Tools.write_result_log("Download BEGIN : [#{url}]")
    System.cmd(@youtube_dl_executable_file, @youtube_dl_options ++ [url], stderr_to_stdout: true)
  end

  @doc """

      Function : get_url_from_urlpid_list
      Input :
        - list of tuple of {pid, URL} eg : [{pid1, URL1}, {pid2, URL2}, {pid3, URL3}]
        - pid

      Output : URL

      Utilize Enum.filter
      # Enum.filter([1, 2, 3], fn x -> rem(x, 2) == 0 end)
      # result :  [2]

  """

  def get_url_from_urlpid_list(urlpid_list, task_pid) do

    result = Enum.filter(urlpid_list, fn {pid, _} -> pid == task_pid end)

    case result do
        [{_, url}] ->
          url
        _ ->
          :ok
    end
  end

end
