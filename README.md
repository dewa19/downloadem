# Project Title

<b>Downloadem</b> is an implementation of Elixir wrapper for simultaneously Youtube video downloader. It builds on top of [youtube-dl](https://youtube-dl.org/).

## Getting Started

Downloadem build on top of youtube-dl, an cli-based youtube.com video downloader. It will read a file contain list urls of youtube videos (not a playlist) and download them simultaneously by creating separated process running youtube-dl for each url. All videos will be saved in a "downloaded" folder under application directory structure.

The benefit of this approach is that all download processes running simultaneously. Youtube-dl can download multiple urls by putting each of them one after another, but still they will be executed sequentially that means the next download will happening once previous download process completed.

I wrote this as part of my journey of learning Elixir as backend service, so yes it's for educational purpose.

### Prerequisites

1. This application utilizes external download engine, youtube-dl. You need to install this program first, because later in application script you will need to specify absolute full path of this executable youtube-dl.
2. You need to specify the list of Youtube video URLs you want to download, in newline-delimited text file in "data" folder under application directory.

### Installing

After clone this application, make this adjustment before you start.

1. Under application directory, open /lib/downloadem.ex
2. Change this constant value according to your local setting, @youtube_dl_executable_file
3. Add some URLs of Youtube video you want to download in /data/url_list.txt

Now you can test to compile & running the application.
If everything works fine, you will see some result in standard output. Also you can see log file (/log/downloadem_YYYYMMDD.log) will be updated, and downloaded video saved in /downloaded folder.

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

[TBD]
