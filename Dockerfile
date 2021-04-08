FROM debian:sid-slim
LABEL maintainer="Christian Diener <mail@cdiener.com>"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        less \
        locales \
        vim-tiny \
        wget \
        ca-certificates \
        fonts-texgyre \
        python3 \
        python3-pip \
        ncbi-blast+ \
        git \
        libglpk-dev \
        r-base-core \
        r-base-dev \
        r-base \
        exonerate \
        bedtools \
        barrnap \
        bc \
        curl \
        libsbml5-dev \
        procps

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN R -e 'install.packages(c("data.table", "stringr", "sybil", "getopt", "reshape2", "doParallel", "foreach", "R.utils", "stringi", "glpkAPI", "CHNOSZ", "jsonlite", "remotes"))'
RUN R -e 'install.packages("BiocManager"); BiocManager::install("Biostrings")'
RUN R -e 'remotes::install_git("https://gitlab.cs.uni-duesseldorf.de/general/ccb/sybilSBML.git")'

RUN cd /opt && git clone https://github.com/jotech/gapseq && chmod -R a+rw /opt/gapseq
RUN cd /usr/bin && ln -s /opt/gapseq/gapseq
RUN cd /opt/gapseq/ && src/./update_sequences.sh

RUN rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

CMD ["gapseq"]
