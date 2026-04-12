.PHONY: html clean livehtml

html:
	uv run --project . sphinx-build -b html source build/html

clean:
	rm -rf build

livehtml:
	uv run --project . sphinx-autobuild source build/html --open-browser
