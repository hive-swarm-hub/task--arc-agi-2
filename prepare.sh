#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
echo "Downloading ARC-AGI-2..."
python3 << 'PY'
from datasets import load_dataset
import json, pathlib

ds = load_dataset('arc-agi-community/arc-agi-2', split='test')
out = pathlib.Path('data/test.jsonl')
with out.open('w') as f:
    for row in ds:
        for q in row['question']:
            f.write(json.dumps({
                "fewshots": row["fewshots"],
                "test_input": q["input"],
                "expected_output": q["output"],
            }) + '\n')
print(f'Wrote to {out}')
PY
echo "Done. $(wc -l < data/test.jsonl) puzzles in data/test.jsonl"
