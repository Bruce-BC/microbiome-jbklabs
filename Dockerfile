# ==============================================================================
# [VERSION FIXED] QIIME2 Core Distribution: 2026.4
# ==============================================================================
FROM quay.io/qiime2/qiime2:2026.4

LABEL maintainer="Microbiome Pipeline Developer"

# 로컬의 환경설정 yaml 복사
COPY envs/qiime2_16s_env.yaml /workspace/envs/qiime2_16s_env.yaml

# DAG 생성을 위해 graphviz 설치
RUN apt-get update && apt-get install -y graphviz && rm -rf /var/lib/apt/lists/*

# OOM 방지를 위해 conda 대신 pip로 snakemake 설치
RUN /opt/conda/envs/rachis-qiime2-2026.4/bin/pip install snakemake pandas seaborn matplotlib scipy

WORKDIR /workspace

CMD ["/bin/bash"]
