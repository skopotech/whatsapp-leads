#!/usr/bin/env bash
#
# The project's verification contract. The harness (hooks, review, CI) only knows this interface:
#
#   scripts/verify.sh quick <files...>   fast: types, lint and tests for what these files touch.
#                                        Called by the Stop hook at the end of every turn.
#   scripts/verify.sh full [<app>]       everything, as in CI. Run once, before the commit that
#                                        closes the ticket. In a monorepo, <app> limits it to one app
#                                        (see docs/monorepo.md); without it, every app.
#
# Exit 0: ok. Anything else: failed, and the output says why.
#

set -euo pipefail

mode=${1:-}
shift || true

case "$mode" in
quick)
  go vet ./... && golangci-lint run --new-from-rev=HEAD && go test ./...
  ;;
full)
  unformatted=$(gofmt -l .)
  [[ -z "$unformatted" ]] || { printf 'gofmt: run gofmt -w on:\n%s\n' "$unformatted" >&2; exit 1; }
  go vet ./... && golangci-lint run && go test -race ./...
  ;;
*)
  echo "usage: scripts/verify.sh quick <files...> | full [<app>]" >&2
  exit 64
  ;;
esac
