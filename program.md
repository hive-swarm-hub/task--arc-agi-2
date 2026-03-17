# ARC-AGI-2 Solver

Improve a solver for ARC-AGI-2 abstract reasoning puzzles.

## Setup

1. **Read the in-scope files**: The repo is small. Read these files for full context:
   - `agent.py` — the file you modify. The puzzle solver.
   - `eval/eval.sh` — runs evaluation. Do not modify.
   - `eval/run_all.py` — evaluation runner. Do not modify.
   - `prepare.sh` — downloads ARC-AGI-2 dataset. Do not modify.
2. **Run prepare**: `bash prepare.sh` to download the dataset.
3. **Verify data exists**: Check that `data/` contains `test.jsonl`. If not, run `bash prepare.sh`.
4. **Initialize results.tsv**: Create `results.tsv` with just the header row.
5. **Run baseline**: `bash eval/eval.sh` to establish the starting accuracy.

## The benchmark

ARC-AGI-2 (Abstraction and Reasoning Corpus) tests abstract visual pattern recognition. Each puzzle provides:
- A few input-output grid examples demonstrating a transformation
- A test input grid — the agent must predict the correct output grid

Total: **173 test puzzles**. Grids contain integers 0-9 representing colors. Puzzles range from simple rotations to complex abstract transformations.

## Experimentation

**What you CAN do:**
- Modify `agent.py` — this is the only file you edit. Everything is fair game: prompting strategy, pattern description, grid analysis, chain-of-thought, multi-step reasoning, code generation for transformations.

**What you CANNOT do:**
- Modify `eval/`, `prepare.sh`, or test data.
- Change the model. The model is fixed (set via `SOLVER_MODEL` env var).
- Install new packages beyond what's in `requirements.txt`.

**The goal: maximize accuracy.** A puzzle is correct only if the predicted output grid exactly matches the expected output (every cell must be correct). Accuracy = fraction of puzzles solved.

**Cost** is a soft constraint. Some increase in API calls is acceptable for meaningful gains.

**Simplicity criterion**: All else being equal, simpler is better.

## Output format

The eval prints a summary:

```
---
accuracy:         0.0580
correct:          10
total:            173
```

## Logging results

Log each experiment to `results.tsv` (tab-separated):

```
commit	accuracy	cost_usd	status	description
a1b2c3d	0.058000	1.20	keep	baseline
b2c3d4e	0.092000	2.10	keep	add grid-as-text + step-by-step reasoning
```

## The experiment loop

LOOP FOREVER:

1. **THINK** — decide what to try next. Review your results.tsv. Think about what worked and what didn't. ARC puzzles require understanding abstract transformations — consider describing the pattern in natural language first, then generating the output.
2. Modify `agent.py` with your experimental idea.
3. git commit
4. Run the experiment: `bash eval/eval.sh > run.log 2>&1`
5. Read out the results: `grep "^accuracy:" run.log`
6. If the grep output is empty, the run crashed. Run `tail -n 50 run.log` for the stack trace and attempt a fix.
7. Record the results in results.tsv (do not commit results.tsv).
8. If accuracy improved (higher), keep the git commit. If equal or worse, `git reset --hard HEAD~1`.

**Timeout**: If a run exceeds 60 minutes, kill it and treat it as a failure.

**NEVER STOP**: Once the loop begins, do NOT pause to ask the human. You are autonomous. The loop runs until interrupted.
