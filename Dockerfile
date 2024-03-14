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
        procps \
        libcurl4-openssl-dev

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN R -e 'install.packages(c("data.table", "stringr", "getopt", "reshape2", "doParallel", "foreach", "R.utils", "stringi", "glpkAPI", "CHNOSZ", "jsonlite", "remotes"))'
RUN R -e 'install.packages("BiocManager"); BiocManager::install("Biostrings")'
RUN R -e 'remotes::install_url("https://cran.r-project.org/src/contrib/Archive/sybil/sybil_2.2.0.tar.gz")'
RUN R -e 'remotes::install_url("https://cran.r-project.org/src/contrib/Archive/sybilSBML/sybilSBML_3.1.2.tar.gz")'

RUN cd /opt && git clone https://github.com/jotech/gapseq
RUN cd /usr/bin && ln -s /opt/gapseq/gapseq
RUN cd /opt/gapseq/ && src/./update_sequences.sh
RUN chmod -R a+rw /opt/gapseq

RUN python3 -m pip install memote --break-system-packages

RUN rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

CMD ["gapseq"]
