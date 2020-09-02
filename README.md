# Downloadem

<b>Downloadem</b> is an implementation of Elixir wrapper for simultaneously Youtube video downloader. It builds on top of [youtube-dl](https://youtube-dl.org/).

## Getting Started

Downloadem build on top of *youtube-dl*, an cli-based youtube.com video downloader. It will read a file contain list urls of youtube videos (not a playlist) and download them simultaneously by creating separated process running *youtube-dl* for each url. All videos will be saved in a ```/downloaded/``` folder under root application directory structure.

The benefit of this approach is that all download processes running simultaneously. ~~As far as I know youtube-dl can download multiple urls by putting each url one after another, but still they will be executed sequentially that means the next download will happening once previous download process completed.~~

*I wrote this as part of my journey of learning Elixir as backend service, so yes it's for educational purpose.*

### Prerequisites

1. This application utilizes external download engine, *youtube-dl*. You need to install this program first, because later in application script you will need to specify absolute full path of this executable *youtube-dl*.
2. You need to specify the list of Youtube video URLs you want to download, in newline-delimited text file in ```/data/url_list.txt```. As a sample, there are 2 URLs there. You can add or replace them with yours.

### Installing

After clone this application, make these adjustments before you start.

1. Under application directory, open ```/lib/downloadem.ex```
2. Change this constant value according to your local setting, @youtube_dl_executable_file
3. Add some URLs of Youtube video you want to download into this file ```/data/url_list.txt```

Now you can test to compile & running the application.
If everything works fine, you will see some result in standard output. Also you can see log file ```/log/downloadem_YYYYMMDD.log``` will be updated, and downloaded video are saved in ```/downloaded``` folder.

That's it!
```
<your_terminal:$> iex -S mix
Erlang/OTP 23 [erts-11.0.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Compiling 1 file (.ex)
Interactive Elixir (1.10.3) - press Ctrl+C to exit (type h() ENTER for help)

iex(1)> Downloadem.execute_download()
Download BEGIN : [https://www.youtube.com/watch?v=7-qGKqveZaM]
Download BEGIN : [https://www.youtube.com/watch?v=tPEE9ZwTmy0]
Download END : [https://www.youtube.com/watch?v=tPEE9ZwTmy0]
Download END : [https://www.youtube.com/watch?v=7-qGKqveZaM]
:ok
iex(2)>

```

## Deployment

#### 1. Direct copy-paste to target machine

Assuming the target machine already has all component needed for running basic Elixir application (ie: Erlang Runtime System & Elixir compiler), the simplest way to running the application from command line is to copy/upload all application's directory structure to remote machine and execute it there with ```mix run``` command.

Two easy steps to install:

a. In case you don't have *youtube-dl* in your remote machine, copy it from your local machine
eg :
```
scp  /local_machine/Downloads/youtube-dl username@xxx.xxx.xxx.xxx:/remote_machine/downloadem/download_engine
```

b. Open *downloadem.ex*, you might want to adjust following variables :
```
@url_file_location "data/url_list.txt" #change this to preferred location
@youtube_dl_download_folder "downloaded" #change this to preferred location
@youtube_dl_executable_file "/home/your_remote_machine/downloadem/download_engine/youtube-dl"

```
If everything goes well, then you can run it this way:

```
your_remote_machine/downloadem>$ mix run -e "Downloadem.execute_download()"
Compiling 1 file (.ex)
Download BEGIN : [https://www.youtube.com/watch?v=7-qGKqveZaM]
Download BEGIN : [https://www.youtube.com/watch?v=tPEE9ZwTmy0]
Download END : [https://www.youtube.com/watch?v=tPEE9ZwTmy0]
Download END : [https://www.youtube.com/watch?v=7-qGKqveZaM]
your_remote_machine/downloadem>$

```

#### 2. Deployment using [Mix Releases](https://hexdocs.pm/mix/Mix.Tasks.Release.html)

**a) Release (Building Package)**

  - Initiate release process
    ```
    $your_local_machine/downloadem>$ mix release.init

    ```

  - Add this part in your mix.exs, under "project"
    ```
    releases: [
      downloadem_linux: [
        include_executables_for: [:unix],
        applications: [runtime_tools: :permanent],
        include_erts: true,
        path: "/path_where_release_package_will_be_saved/Release",
        steps: [:assemble, :tar]
      ]
      ```

  - Copy following folders into ```rel/overlays``` : data, download_engine, downloaded, & log
    (everything under ```rel/overlays``` will be included in final tar.gz package)

  - Build package
    ```
    $your_local_machine/downloadem>$ MIX_ENV=prod mix release downloadem_linux

    ```

**b) Deployment**

  - Copy tar.gz to target machine
    eg:
    ```
    scp downloadem_linux-0.1.0.tar.gz   username@xxx.xxx.xxx.xxx:target_machine/downloadem_linux/

    ```

  - Extract package file
    ```
    <target_machine/downloadem_linux>$ tar -xf  downloadem_linux-0.1.0.tar.gz

    ```

  - Execute program
    ```
    <target_machine/downloadem_linux>$ bin/downloadem_linux eval "Downloadem.execute_download()"
    Download BEGIN : [https://www.youtube.com/watch?v=7-qGKqveZaM]
    Download BEGIN : [https://www.youtube.com/watch?v=tPEE9ZwTmy0]
    Download END : [https://www.youtube.com/watch?v=tPEE9ZwTmy0]
    Download END : [https://www.youtube.com/watch?v=7-qGKqveZaM]

    ```

 That's the final step of deployment process. I wrote some notes/finding during this process [here](TBD)
