FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV VENV_PATH=/opt/venv
ENV PATH="$VENV_PATH/bin:$PATH"
ENV JUPYTER_PORT=8888

# System dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create venv
RUN python3 -m venv $VENV_PATH

# Clone your work repo
RUN git clone https://github.com/Narwhal-TCC/data-science-notebooks.git /opt/lab && \
    cd /opt/lab && \
    pip install -r requirements.txt

# Clone component repo and install it
RUN git clone https://github.com/Narwhal-TCC/sonar-feature-extractor.git /opt/component && \
    pip install --upgrade pip && \
    pip install build && \
    cd /opt/component && \
    pip install .

# Install your project dependencies + JupyterLab
RUN pip install jupyterlab && \
    if [ -f pyproject.toml ]; then pip install .; fi

# Mount point for datasets and results (populated at runtime by EBS)
RUN mkdir -p /mnt/data

EXPOSE 8888

CMD ["jupyter", "lab", \
     "--ip=0.0.0.0", \
     "--port=8888", \
     "--no-browser", \
     "--allow-root", \
     "--notebook-dir=/opt/lab", \
     "--NotebookApp.token=''", \
     "--NotebookApp.password=''"]
