#!/bin/bash

scripts=$(dirname "$0")
base=$(realpath "$scripts/..")

models=$base/models
data=$base/data
tools=$base/tools
logs=$base/logs

mkdir -p $models $logs

# Adjust for the number of threads or set your GPU device here
num_threads=4
device=0   # E.g., device=0 if you want to use CUDA_VISIBLE_DEVICES=0 on a GPU

# Check if dropout was passed
if [ -z "$1" ]; then
  echo "Running Task 1: Baseline model without dropout"
  dropout=0.5
  model_name="model_europarl.pt"
  log_file="$logs/log_baseline.log"
else
  dropout=$1
  echo "Running Task 2: Dropout=$dropout"
  model_name="model_dropout_${dropout}.pt"
  log_file="$logs/dropout_${dropout}.log"
fi

SECONDS=0


(
    cd $tools/pytorch-examples/word_language_model || exit

    # Train on Europarl data 
    CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python main.py \
        --data $data/europarl \
        --epochs 30 \
        --batch_size 30 \
        --log-interval 100 \
        --emsize 256 \
        --nhid 256 \
        --dropout $dropout \
        --tied \
        --cuda \
        --save $models/$model_name \
        --logfile $log_file
)

echo "Time taken:"
echo "$SECONDS seconds"