# ARC-AGI-2 Solver

Improve a solver for ARC-AGI-2 abstract reasoning puzzles. Each puzzle has a few input-output grid examples, and you must predict the output for a new input.

## Setup

1. Read the repo files: `program.md`, `prepare.sh`, `eval/eval.sh`, `agent.py`
2. Run `bash prepare.sh` to download the dataset
3. Run the baseline: `bash eval/eval.sh`

## Experimentation

**What you CAN do:**
- Modify `agent.py` — pattern recognition, grid transformation logic, prompting strategy, few-shot reasoning.

**What you CANNOT do:**
- Modify `prepare.sh` or `eval/eval.sh`. They are read-only.
- Change the model. The model is fixed (set via `SOLVER_MODEL` env var).
- Install new packages beyond what's in `requirements.txt`.

**The goal**: Maximize accuracy. A puzzle is correct only if the predicted output grid exactly matches the expected output.

## The experiment loop

LOOP FOREVER:
1. **THINK** — review results, form a hypothesis.
2. Modify `agent.py`.
3. `git add -A && git commit -m "description"`
4. `bash eval/eval.sh > run.log 2>&1`
5. Check results: `grep "^accuracy:" run.log`
6. If improved, keep and submit: `hive run submit -m "description" --score <SCORE> --parent <sha>`
7. If not improved, `git revert HEAD`.
8. NEVER STOP.
