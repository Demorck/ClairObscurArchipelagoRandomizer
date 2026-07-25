#!/usr/bin/env python3
"""
Sort UE4SS hook-log dumps by actual call time (chronological), across all
function sections, while keeping each call's function-name label.

Expected input format (repeated blocks separated by lines of 3+ dashes):

    FunctionName

    Received call @ HH:MM:SS.fffffff.
      Context:
        ...
      Locals:
        ...
      Out:
        ...
      ReturnValue
        ...

    Received call @ HH:MM:SS.fffffff.
      ...

    --------------

    NextFunctionName
    ...

Usage:
    python sort_hooks_by_time.py <input.txt> [output.txt]

If output.txt is omitted, writes "<input>_sorted.txt" next to the input file.

AI generated (much faster and very useful tbh)
"""

import re
import sys
from pathlib import Path

CALL_RE = re.compile(r"Received call @ (\d{2}:\d{2}:\d{2}\.\d+)\.")


def parse_sections(text: str):
    """Split raw text into (function_name, section_body) pairs."""
    parts = re.split(r"\n-{3,}\s*\n", text)
    sections = []
    for part in parts:
        lines = part.strip("\n").split("\n")
        name = next((l.strip() for l in lines if l.strip()), None)
        if name is None:
            continue
        sections.append((name, part.strip("\n")))
    return sections


def split_calls(name: str, body: str):
    """Split a section's body into individual 'Received call' blocks."""
    lines = body.split("\n")
    # Find start indices of each call block
    call_starts = [i for i, l in enumerate(lines) if CALL_RE.search(l)]
    blocks = []
    for idx, start in enumerate(call_starts):
        end = call_starts[idx + 1] if idx + 1 < len(call_starts) else len(lines)
        block_lines = lines[start:end]
        # trim trailing blank lines
        while block_lines and not block_lines[-1].strip():
            block_lines.pop()
        timestamp = CALL_RE.search(lines[start]).group(1)
        blocks.append((timestamp, name, "\n".join(block_lines)))
    return blocks


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    in_path = Path(sys.argv[1])
    out_path = Path(sys.argv[2]) if len(sys.argv) > 2 else in_path.with_name(
        in_path.stem + "_sorted_by_time" + in_path.suffix
    )

    text = in_path.read_text(encoding="utf-8")
    sections = parse_sections(text)

    all_blocks = []
    for name, body in sections:
        all_blocks.extend(split_calls(name, body))

    # Timestamps share the same fixed-width "HH:MM:SS.fffffff" format here,
    # so a plain string sort is chronological. If widths ever differ, replace
    # the key with a proper time-parsing function.
    all_blocks.sort(key=lambda b: b[0])

    out_lines = []
    for timestamp, name, block in all_blocks:
        out_lines.append(f"{name}\n\n{block}")

    out_path.write_text("\n\n--------------\n\n".join(out_lines) + "\n", encoding="utf-8")

    print(f"{len(all_blocks)} calls sorted chronologically -> {out_path}")


if __name__ == "__main__":
    main()
