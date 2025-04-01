#! /bin/bash

scripts=$(dirname "$0")
base=$(realpath $scripts/..)

models=$base/models
data=$base/data
tools=$base/tools
samples=$base/samples

mkdir -p $samples

num_threads=4
device=""

# Handle optional dropout argument
if [ -z "$1" ]; then
    echo "Generating from baseline model (no specified dropout)"
    model_name="model_europarl"
    sample_file="sample_baseline.txt"
else
    echo "Generating from model with dropout=$1"
    model_name="model_dropout_$1"
    sample_file="sample_dropout_$1.txt"
fi


(cd $tools/pytorch-examples/word_language_model &&
    CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python generate.py \
        --data $data/europarl \
        --words 100 \
        --checkpoint $models/$model_name.pt \
        --outf $samples/$sample_file
)
