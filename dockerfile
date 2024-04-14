FROM python:3.8

# =================== Development =========================
# The main purpose of this image is to be used for develpers
# Don't use it in production.
# =========================================================

# It works in Mac M1 and other arms devices.
# If you use x86 or x64 edit this line.
ENV ARCH "arm64"

# Tip: use docker-compose file to mount your repository folder here /home/dev.
RUN mkdir -p /home/dev 

WORKDIR /home

# Linux
RUN apt-get update && apt-get install -y bash zsh curl wget zip git net-tools ffmpeg libsndfile1 wget tree

# OhMyZsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Python
RUN pip install --upgrade pip
RUN pip3 install musdb museval
RUN apt-get update && apt-get install -y libhdf5-dev=1.10.8+repack1-1

# The 4stems model is embedded in this image.
RUN mkdir -p /home/pretrained_models/4stems
RUN wget https://github.com/deezer/spleeter/releases/download/v1.4.0/4stems.tar.gz
RUN tar -xz -f 4stems.tar.gz -C /home/pretrained_models/4stems
RUN rm 4stems.tar.gz

# Install spleeter from source code.
RUN mkdir -p /tmp/source/spleeter
ADD ./ /tmp/source/spleeter
RUN pip3 install /tmp/source/spleeter
RUN rm -rf /tmp/source/spleeter

# This folder can be used to save audio files
RUN mkdir -p /home/outputs

ENTRYPOINT ["zsh"]

# You will be able to run spleeter following these steps.
# 1 - Connect to container.
# 2 - Enter in /home folder.
# 3 - Execute: spleeter separate -p spleeter:4stems --codec mp3 -o outputs/ path/to/audio_example.mp3

# obs. If you mounted the git repository folder in /home/dev you can use dev/audio_example.mp3 as sample of file.
