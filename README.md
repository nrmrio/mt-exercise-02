# MT Exercise 2: Pytorch RNN Language Models

This repo shows how to train neural language models using [Pytorch example code](https://github.com/pytorch/examples/tree/master/word_language_model). Thanks to Emma van den Bold, the original author of these scripts. 

---

## Requirements

- This only works on a Unix-like system, with bash.
- Python 3 must be installed on your system, i.e. the command `python3` must be available
- Make sure `virtualenv` is installed on your system. To install, e.g.:

  ```bash
  pip install virtualenv
  ```

---

## Setup Steps

1. **Clone this repository in the desired place**:

    ```bash
    git clone https://github.com/YOUR_USERNAME/mt-exercise-02
    cd mt-exercise-02
    ```

2. **Create a new virtualenv using Python 3**:

    ```bash
    ./scripts/make_virtualenv.sh
    ```

    Then activate the environment (the script will show the `source` command to use):
    
    ```bash
    source venvs/torch3/bin/activate
    ```

3. **Install all required packages**:

    ```bash
    ./scripts/install_packages.sh
    ```

4. **Download and preprocess the dataset**:

    ```bash
    ./scripts/download_data.sh
    ```

    >  **Adaptation**: The script was modified to download the [Europarl English corpus](https://object.pouta.csc.fi/OPUS-Europarl/v3/mono/en.txt.gz), sample **3,000 random lines**, and limit the vocabulary size to **10,000 words**. The preprocessed output is split into `train.txt`, `valid.txt`, and `test.txt`.

---

## Training

To train a model:

```bash
./scripts/train.sh
```

> I adapted `scripts/train.sh` to point to the Europarl dataset, save the model checkpoint in `models/`, and allow easy dropout experimentation.

You can customize training settings via arguments. For example:

```bash
./scripts/train.sh 0.4
```

This sets dropout to `0.4` and saves the model and logs accordingly.

---

## Generate Text Samples

After training, generate new text from a model with:

```bash
./scripts/generate.sh
```

> This script was adapted to accept a custom model checkpoint and output path. Use it to compare text from the best- and worst-performing models (based on test perplexity).

---

## Script Enhancements

### `scripts/train.sh` was enhanced to:
- Accept a **dropout value** as an argument (e.g., `./scripts/train.sh 0.2`)
- Default to **baseline (dropout=0.5)** if no argument is passed
- Save models as: `models/model_dropout_0.2.pt`, `model_dropout_0.6.pt`, etc.
- Log **training and validation perplexities** into: `logs/dropout_0.2.log`, etc.
- Set default: `batch_size=30`, `epochs=30`

### `tools/pytorch-examples/word_language_model/main.py` was modified to:
- Add a `--logfile` flag
- Log a **header row**: `epoch	train_ppl	valid_ppl`
- Log **per-epoch training and validation perplexities** in tabular format
- Log **final test perplexity** after training
- Ensure format is **CSV/TSV-compatible** for easy analysis

### `scripts/generate.sh` was adjusted to:
- Accept a specific model checkpoint
- Output generated samples to a specified file
- Allow generation from any trained model (e.g., best or worst dropout)

### `scripts/analyze_dropout.py` (new):
- Loads log files from `logs/`
- Plots **training vs. validation perplexity** over epochs
- Extracts and ranks **test perplexities** across all dropout settings
- Saves line charts to `plots/` for inclusion in reports

---

## Results and Reporting

I trained **7 models** with different dropout settings:

- Dropout: **0.0**, **0.2**, **0.3**, **0.4**, **0.5 (default baseline)**, **0.6**, **0.8**

From these, I:
- Logged and compared perplexities over 30 epochs
- Identified the best-performing dropout based on **lowest test perplexity**
- Generated sample outputs from the best and worst models
- Plotted and included graphs of training/validation perplexity for each

---

## Submission

All changes and results are committed to this forked repository.  
See `logs/`, `plots/`, and `samples/` for outputs.  
All scripts are runnable as documented above.
---

## Generating Text from Specific Models

You can now generate text from any trained model by passing an optional dropout value to the `generate.sh` script.

### Usage:

```bash
# Baseline (no dropout specified)
./scripts/generate.sh

# From dropout-trained model (e.g. 0.4)
./scripts/generate.sh 0.4
```

This will use:

- `models/model_europarl.pt` for baseline
- `models/model_dropout_0.4.pt` for dropout 0.4

And output the results into:

- `samples/sample_baseline.txt`
- `samples/sample_dropout_0.4.txt`

All generation is performed from the Europarl dataset trained models.
---

## Final Notes

- All scripts are runnable from a standard Unix-like terminal.
- Results are reproducible across different dropout settings using the provided scripts.
- All model checkpoints, logs, and generated outputs are stored in their respective folders: `models/`, `logs/`, and `samples/`.

Example directory structure after training:
```
models/
  model_dropout_0.0.pt
  model_dropout_0.4.pt
logs/
  dropout_0.0.log
  dropout_0.4.log
samples/
  sample_baseline.txt
  sample_dropout_0.4.txt
```

Evaluation results and charts are located in the `plots/` directory.