# 16S Microbiome QIIME2 CLI 파이프라인

본 프로젝트는 QIIME2(`2026.4` 버전) 기반으로 300bp Paired-end 16S rRNA 시퀀싱 데이터를 Beta 다양성까지 논스톱 자동 분석하는 파이프라인입니다. 모듈형 아키텍처로 구성되어 있으며, 단일 CLI 명령어로 외부 Raw 데이터와 Output 경로를 자유롭게 매핑하여 사용할 수 있습니다.

## 1. 디렉토리 구조
```text
microbiome-pipeline/
├── bin/
│   └── microbiome_16s_cli         # [독립 실행] 파이프라인 구동 CLI
├── workflow/
│   ├── Snakefile                  # 16S 분석 오케스트레이션 로직
│   └── config.yaml                # 16S 분석 파라미터 (DADA2 Trimming 등)
├── envs/
│   └── qiime2_16s_env.yaml        # QIIME2 + Snakemake 런타임 명세
└── db/
    └── 16s_classifiers/           # 참조 DB(SILVA/Greengenes) 보관
```

## 2. 초기 컨테이너 빌드

파이프라인 실행 환경은 제공된 `Dockerfile`과 `envs/` 내부의 명세를 통해 완벽히 재현됩니다.

```bash
docker build -t microbiome_qiime2:latest .
```

## 3. 파이프라인 실행 방법

`bin/microbiome_16s_cli` 명령어 하나로 데이터를 불러오고, 분석 결과를 지정된 폴더에 저장합니다. 
(CLI 내부에서 자동으로 `docker run` 명령어로 변환되어 볼륨이 마운트됩니다.)

### 기본 실행 (메타데이터 자동 생성)
```bash
./bin/microbiome_16s_cli \
    --raw_data /absolute/path/to/my_fastq \
    --out_dir /absolute/path/to/my_results \
    --cores all
```
*주의: 메타데이터를 명시하지 않으면 `--out_dir` 쪽에 임의의 `metadata.tsv`를 자동 생성하여 분석을 지속합니다.*

### 커스텀 메타데이터 파일 지정
```bash
./bin/microbiome_16s_cli \
    --raw_data /absolute/path/to/my_fastq \
    --out_dir /absolute/path/to/my_results \
    --metadata /absolute/path/to/my_metadata.tsv
```

## 4. 분석 결과

명령어 실행이 완료되면 지정하신 `--out_dir` 내부에 다음 항목이 생성됩니다:
- `import/`: Demultiplexed QIIME2 아티팩트 및 QC 요약(`.qzv`)
- `dada2/`: ASV Table, Denoising Stats, Representative Sequences 및 각종 시각화(`.qzv`)
- `taxonomy/`: 종 동정 결과 및 Barplot 시각화(`.qzv`)
- `diversity/`: **[Beta Diversity 포함]** Core Metrics Phylogenetic 결과물(PCoA 등) 및 Alpha Rarefaction 시각화(`.qzv`)
- `phylogeny/`: 계통수 분석 산출물

`.qzv` 확장자는 [QIIME2 View](https://view.qiime2.org)에 드래그 앤 드롭하여 바로 브라우저에서 확인할 수 있습니다.
