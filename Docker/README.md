To run build and run this Docker container:

1.) Install Docker on your machine

2.) Download the Dockerfile & config.toml from this folder

3.) Open config.toml in a text editor and adjust the settings to match your environment (IP address, etc.)

4.) Open a shell and cd to the directory where both files are located

5.) docker build . -t wallop

  This will take some time (~720 seconds) as ffmpeg is manually compiled from source to use AAC audio, there may be a workaround not sure

6.) docker run --rm --name wallop -v /path/to/config.toml:/wallop/config/config.toml -p 8888:8888 wallop

  Make sure to change the above path, and make sure it's an absolute path ^ (Ex: /Volumes/MyDrive/config.toml:/wallop/config/config.toml)

7.) Launch a browser http://localhost:8888 
