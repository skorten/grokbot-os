# Releasing

1. Run `bash scripts/check.sh`. Fix anything it reports before you continue.
2. Set `VERSION` to the new `X.Y.Z`. Add that version to `CHANGELOG.md` and summarize what changed.
3. Merge the release pull request into `main`.
4. On `main`, create an annotated tag `vX.Y.Z` for the merge commit. The tag name matches `VERSION`, with a leading `v`.
5. Publish a GitHub Release for that tag. Use the changelog section for that version as the release notes.

Tag from `main` after the merge. Do not tag a feature branch.
