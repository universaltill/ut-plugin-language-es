# Review: line-discount keys (es), ut-docs#4627

This change translates the 2 keys that universal-till added for ut-docs#4627:

- `basket.discount_too_large`: the note under a basket line when its
  discount would be more than the line total.
- `pos.toast.line_discount_too_large`: the tender toast that names the
  line.

It also bumps `manifest.json` to 1.1.247.

**Reviewer:** Sonnet 5.5, an independent pass (the author model was Opus
5.5; Fable was refused for lack of credits). It found nothing on these
strings:
- each has one `%s`, in the same order as English;
- quoting and terminology follow the neighbouring `basket.discount_short`
  and `pos.toast.tax_unavailable`.

**Verified:**
- `scripts/validate.sh` passes.
- `scripts/check-key-drift.sh` against core's branch `en.json`: 0 drift,
  0 orphans, 0 token mismatches.

**Verdict:** safe to merge once universal-till's ut-docs#4627 change is on
`main`.
