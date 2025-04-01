#!/bin/bash

scripts=$(dirname "$0")
base=$(realpath "$scripts/..")

data=$base/data
tools=$base/tools

mkdir -p "$data/europarl"
mkdir -p "$data/europarl/raw"

cd "$data/europarl/raw" || exit

echo "=== Downloading Europarl (English) ==="
wget https://object.pouta.csc.fi/OPUS-Europarl/v3/mono/en.txt.gz -O europarl.en.txt.gz

echo "=== Decompressing ==="
gunzip europarl.en.txt.gz

# Sampling 30,000 lines.
SAMPLE_SIZE=30000
echo "=== Sampling ${SAMPLE_SIZE} lines randomly ==="
shuf europarl.en.txt | head -n "$SAMPLE_SIZE" > europarl.sampled.txt

echo "=== Preprocessing (tokenize + limit vocab) ==="
# If your preprocess.py handles tokenization & optional vocab limit:
python "$base/scripts/preprocess.py" \
    --vocab-size 10000 \
    --tokenize \
    --lang "en" \
    --sent-tokenize \
    < europarl.sampled.txt \
    > europarl.sampled.preprocessed.txt

# Split into train, valid, test
echo "=== Splitting into train/valid/test ==="
TOTAL_LINES=$(wc -l < europarl.sampled.preprocessed.txt)
TRAIN_SIZE=$(( (SAMPLE_SIZE * 80) / 100 ))  # 80% for train
VALID_SIZE=$(( (SAMPLE_SIZE * 10) / 100 ))  # 10% for valid
# The last 10% will be for test

head -n "$TRAIN_SIZE" europarl.sampled.preprocessed.txt > "$data/europarl/train.txt"
head -n $((TRAIN_SIZE + VALID_SIZE)) europarl.sampled.preprocessed.txt | tail -n "$VALID_SIZE" > "$data/europarl/valid.txt"
tail -n $((SAMPLE_SIZE - TRAIN_SIZE - VALID_SIZE)) europarl.sampled.preprocessed.txt > "$data/europarl/test.txt"

echo
echo "=== Done! Your Europarl data is in: $data/europarl ==="
echo "=== Line counts: ==="
wc -l "$data/europarl/"*.txt
