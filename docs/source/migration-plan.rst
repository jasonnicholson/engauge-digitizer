Docs Migration Plan
===================

Goal: replace legacy root-level generated website content with maintained Sphinx sources.

Phases:

1. Establish Sphinx scaffold and publish it.
2. Migrate high-value pages first: build docs, troubleshooting, release notes.
3. Migrate help/tutorial pages in batches.
4. Remove legacy generated root files after parity checks.

Current migrated pages:

- overview
- build-and-release
- linux-runtime
- static-linux
- windows-build-status
- cli (command line options)
- coordinates (coordinate system dialog)
- export (export setup dialog)
- tutorials (all 5 tutorial walkthroughs)
- dialogs (curves, measures, discretize, segments, point-match, sessions, curve-geometry, measure-geometry)
- faq (discretizing, line graphs, point graphs, getting data out, measuring, selecting, select mode, floating axes, multiple coord systems, timezone, other help)
- glossary
- faq additions (better accuracy, context menu windows, date formats, fixing axis points, point match requirements)

All 35 legacy ``help/*.html`` pages have now been migrated to Sphinx.

Next steps:

- Remove legacy root-level HTML files after parity check
- Clean up help/ directory (source HTML no longer needed for docs)
