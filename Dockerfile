# ==============================================================================
# [VERSION FIXED] QIIME2 Core Distribution: 2026.4
# ==============================================================================
FROM quay.io/qiime2/qiime2:2026.4

LABEL maintainer="Microbiome Pipeline Developer"

# 로컬의 환경설정 yaml 복사
COPY envs/qiime2_16s_env.yaml /workspace/envs/qiime2_16s_env.yaml

# 기존 rachis-qiime2-2026.4 환경에 snakemake 등 필요 라이브러리 추가 설치
RUN conda env update -n rachis-qiime2-2026.4 -f /workspace/envs/qiime2_16s_env.yaml && \
    conda clean -a -y

WORKDIR /workspace

CMD ["/bin/bash"]
