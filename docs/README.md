11/26/2022

The original <a href="https://github.com/maddox/wallop">wallop</a> project has been sunseted, and the creators have moved on to a new commercial endeavor called <a href="https://www.getchannels.com">Channels</a>.

I have taken it upon myself to re-upload the original code and create a new separate experimental repo, so I can update it, make it more useful for my own purposes, and to learn more about web development.

To be clear: I am a sysadmin and not a dev, and I know next to nothing about Ruby, but this is definitely a great way to learn.

I did not fork the original repo because I don't really know what I am doing here on Github or with editing this code, and I did not want to accidentally bombard the original project folks with notifications & commits etc.

<b>It's very important to understand that THIS version of wallop is NOT designed to be installed and run on macOS/Windows/Linux, it's meant to be run specifically from a Docker container</b>

So far I have changed:

1.) Added option for turning on or off ffmpeg deinterlace filter (-vf bwdif) which is the main thing I wanted to accomplish with this project

2.) Updated <a href="https://github.com/srgzx/wallop/tree/main/Docker">Dockerfile</a> so that it actually builds & runs (works on ARM systems!)

3.) Added additional bitrate options, not sure how useful this will be but we'll see

To do at some point in the future:

1.) Add username / password login (this will be next)

2.) Fix the way Wallop sessions work, because right now they kinda suck...if the streaming settings are changed, and the browser back button is used, you have to wait 60 seconds until it kills the previous session in order to load another stream...hopefully there's a better way to do this?

3.) Add detector for when all tuners are tied up, Wallop currently will endless loop when this happens (not good lol)!

Continue on with the original readme:

# Wallop API

The following helps describe Wallop's HTTP API. While Wallop has an HTML front end, it is primarily for providing an API level service for media center's to consume.

## Workflow

Using Wallop's API. You follow these steps to prepare a stream and consume it.

1. Tune the channel by hitting `/channels/570/tune`.
2. Ping `/channels/570/status` checking on the transcoding session's status.
3. Once the status reports `ready', open `/channels/570.m3u8`

Wallop works a bit asynchronously in that it doesn't block waiting for the stream to start. It's your job to tell it to start the transcode session. You then check it's status at intervals to see if it's ready to stream. Once it's ready, you can then load the `m3u8` and watch your stream.

## Channels

Wallop will return your available channels as well as keep track of your favorite channels.

### Channel Object

``` json
{
"GuideNumber": "570",
"GuideName": "ESPN HD",
"LogoUrl": "http://192.168.1.23:888/logos/cbs.png",
"Favorite": true
}
```

### `GET` /channels

Get a list of your available channels.

**Returns:** Array of channels in a `channel` key.

#### Parameters

* **type**: (OPTIONAL) Filter the channels that are returned. Defaults to all channels - `hd | favorites`

### `PUT` /channels/favorites

Add a channel to your favorites list.

**Returns:** Nothing.

#### Parameters

* **channel**: The numeric channel you want to add to your favorites. `570`

### `DELETE` /channels/favorites

Removes a channel from your favorites list.

**Returns:** Nothing.

#### Parameters

* **channel**: The numeric channel you want to remove from your favorites. `570`

## Streaming

Wallop, of course, will stream the tuned content via HLS.

### `POST` /channels/:channel/tune

This method will tell Wallop to prepare a channel for streaming. It will tune your HDHomeRun and begin transcoding. You can optionally pass in parameters for what resolution and bitrate you would like to transcode with. This is helpful for low bandwidth situations like over cellular data or slow Wi-Fi.

* **channel**: The numeric channel you want to tune and prepare for streaming. `570`

**Returns:** Nothing.

#### Parameters

* **resolution**: (OPTIONAL) The resolution you want to transcode to. You'll want this to be an aspect of 16x9. This defaults to `1280x720`.
* **bitrate**: (OPTIONAL) The bitrate you want to transcode to. Format `2000k`. This defaults to `3000k`.
* **deint**: (OPTIONAL) Turns on or off ffmpeg's bwdif deinterlace filter.  Format `1` or `0`.  Defaults to `0` (off).

### `GET` /channels/:channel/status

Use this method to check the status of the transcode. This will return a JSON object describing the transcode session.

Use the `ready` key in the returned object to determine if it is ready to stream or not.

* **channel**: The numeric channel you want to tune and prepare for streaming. `570`

**Returns:**

``` json
{
"channel":"570",
"ready":false,
"last_read":"Mon Jun 17 15:40:05 -0400 2013",
"pid":57257
}
```

### `POST` /channels/:channel/stop

This method will tell Wallop to immediatly stop the transcode session for the tuned channel.

* **channel**: The numeric channel you want to stop streaming. `570`

**Returns:** Nothing.

### `GET` /channels/:channel/raw

This method will simply redirect you to the raw MPEG2 stream off of the HDHomeRun.

* **channel**: The numeric channel you want to tune and prepare for streaming. `570`

**Returns:** nothing.

### `GET` /channels/:channel.m3u8

This is the direct URL to the HLS stream once the transcode session is `ready`. Be sure not to apply this until the session reports that it is `ready`.

* **channel**: The numeric channel you want to tune and prepare for streaming. `570`

**Returns:** HLS STREAM!
