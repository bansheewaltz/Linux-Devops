FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive
ENV PROMPT_COLOR="\033[38;5;117m" COLOR_RESET="\033[0m"

RUN apt update; \
    apt install -y goaccess \
                   iperf3 \
                   nginx \
                   stress \
                   tzdata \
                   wget; \
    rm -rf /var/lib/apt/lists; \
    echo 'export PS1="${PROMPT_COLOR}\u@ubuntu_container${COLOR_RESET}:/\W# "' \
         >> ~/.bashrc
