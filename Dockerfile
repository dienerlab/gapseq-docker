FROM debian:12
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
        procps \
        libcurl4-openssl-dev \
        parallel \
        libxml2-dev \
        libsbml5-dev \
        bc


RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LD_LIBRARY_PATH /usr/lib64

#RUN wget https://sourceforge.net/projects/sbml/files/libsbml/5.18.0/stable/Linux/64-bit/libSBML-5.18.0-Linux-x64.deb && \
#    wget https://sourceforge.net/projects/sbml/files/libsbml/5.18.0/stable/R%20interface/libSBML_5.18.0.tar.gz && \
#    apt-get install ./libSBML-5.18.0-Linux-x64.deb && \
#    R CMD INSTALL libSBML_5.18.0.tar.gz

RUN R -e 'install.packages(c("data.table", "stringr", "getopt", "R.utils", "stringi", "jsonlite", "httr", "pak"))' && \
    R -e 'install.packages("BiocManager"); BiocManager::install("Biostrings")' && \
    R -e 'pak::pkg_install("Waschina/cobrar")'

RUN cd /opt && git clone https://github.com/jotech/gapseq && cd /usr/bin && ln -s /opt/gapseq/gapseq
RUN cd /opt/gapseq/ && ./src/update_sequences.sh Bacteria && ./src/update_sequences.sh Archaea
RUN chmod -R a+rw /opt/gapseq

RUN python3 -m pip install memote micom --break-system-packages

RUN rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

CMD ["gapseq"]
